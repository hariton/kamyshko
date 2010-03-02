class LoadIssueJob < Struct.new(:issue)

  def perform
    begin
      issue.load_text
      issue.extract_images
      issue.active = true
      issue.save!
      LOADER_LOGGER.info{"Issue processing has successfully finished: #{issue.source.title}, #{issue.number}, #{issue.date}."}
    rescue Exception => e
      LOADER_LOGGER.error{"#{e.message}. Removing issue from DB."}
      issue.destroy
    end
  end

end
