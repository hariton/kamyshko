
def mv(file_path, dir_path)
  # XXX обрабатывать в блоке, логгировать ошибки
  FileUtils.mkpath dir_path unless File.directory?(dir_path)
  FileUtils.mv file_path, dir_path
end

require 'upload_files'

desc 'Load pdf-txt pairs to DB'
task :load_files => :environment do

  config = YAML.load( File.open( Rails.root.join('config/load_files.yml') ))
  config_dirs = config[Rails.env]['dirs']

  Dir.glob( File.join(config_dirs['inbox'], '*.pdf') ).each do |pdf_fpath|

    # TODO: отслеживать обратную ситуацию (для txt-файла нет парного pdf'а)
    txt_fpath = pdf_fpath.chomp(File.extname(pdf_fpath)) + '.txt'
    unless File.exist? txt_fpath
      LOADER_LOGGER.error "Missing '#{txt_fpath}' (txt-pair for '#{pdf_fpath}')"
      mv pdf_fpath, config_dirs['faults']['orphans']
      mv txt_fpath, config_dirs['faults']['orphans']
      next
    end

    fn = File.basename(pdf_fpath).chomp(File.extname(pdf_fpath))
    if fn =~ /^(.+?)_(\d+)_([0-3]?\d)_([01]?\d)_((19|20)\d\d)$/
      source_title, issue_number, issue_day, issue_month, issue_year = $1, $2.to_i, $3.to_i, $4.to_i, $5.to_i
      issue_date = Date.new(issue_year, issue_month, issue_day)
      @source = Source.find_by_title(source_title)
      unless @source
        LOADER_LOGGER.error "Cannot find source with name '#{source_title}' in database. File: '#{pdf_fpath}'"
        mv pdf_fpath, config_dirs['faults']['badnamed']
        mv txt_fpath, config_dirs['faults']['badnamed']
        next
      end

      @issue = @source.issues.find(:first, :conditions => {:number => issue_number, :date => issue_date})
      if @issue
        LOADER_LOGGER.warn "Such issue already exist: #{@issue.source.title}, #{@issue.number}, #{@issue.date}. File: '#{pdf_fpath}'"
        mv pdf_fpath, config_dirs['faults']['duplicates']
        mv txt_fpath, config_dirs['faults']['duplicates']
        next
      end

      @issue = @source.issues.build(:number => issue_number, :date => issue_date)
      @issue.pdf_file = UploadedFile.new(pdf_fpath, 'application/pdf', true)
      @issue.txt_file = UploadedFile.new(txt_fpath, 'text/plain', false)

      if @issue.save
        LOADER_LOGGER.info "Issue successfully processed and placed in queue for loading: #{@issue.source.title}, #{@issue.number}, #{@issue.date}. File: '#{pdf_fpath}'"
        mv pdf_fpath, config_dirs['backup']
        mv txt_fpath, config_dirs['backup']
      else
        LOADER_LOGGER.error "DB refused this issue: #{@issue.source.title}, #{@issue.number}, #{@issue.date}. File: '#{pdf_fpath}'. Error: '#{$!}'"
        mv pdf_fpath, config_dirs['faults']['refused']
        mv txt_fpath, config_dirs['faults']['refused']
      end

    else
      LOADER_LOGGER.warn "Bad filename: '#{pdf_fpath}'"
      mv pdf_fpath, config_dirs['faults']['badnamed']
      mv txt_fpath, config_dirs['faults']['badnamed']
    end

  end

end
