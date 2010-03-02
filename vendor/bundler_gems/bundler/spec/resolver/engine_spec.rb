require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Resolving specs" do
  it "supports a single dependency" do
    index = build_index do
      add_spec "bar", "2.0.0"
    end

    deps = [
      build_dep("bar", ">= 1.2.3"),
    ]

    solution = Bundler::Resolver.resolve(deps, [index])
    solution.should match_gems(
      "bar" => ["2.0.0"]
    )
  end

  it "supports a crazy case" do
    index = build_index do
      add_spec "activemerchant", "1.4.1" do
        runtime "activesupport", ">= 1.4.1"
      end
      add_spec "activesupport", "3.0.0"
      add_spec "activesupport", "2.3.2"
      add_spec "action_pack", "2.3.2" do
        runtime "activesupport", "= 2.3.2"
      end
    end

    deps = [
      build_dep("activemerchant", ">= 0"),
      build_dep("action_pack", "= 2.3.2")
    ]

    solution = Bundler::Resolver.resolve(deps, [index])
    solution.should match_gems(
      "activemerchant" => ["1.4.1"],
      "action_pack" => ["2.3.2"],
      "activesupport" => ["2.3.2"]
    )
  end

  it "supports nested dependencies" do
    index = build_index do
      add_spec "bar", "2.0.0" do
        runtime "foo", ">= 1"
      end
      add_spec "foo", "1.1"
    end

    deps = [
      build_dep("bar", ">= 1.2.3"),
    ]

    solution = Bundler::Resolver.resolve(deps, [index])
    solution.should match_gems(
      "bar" => ["2.0.0"],
      "foo" => ["1.1"]
    )
  end

  it "supports locked dependencies" do
    index = build_index do
      add_spec "bar", "1.0" do
        runtime "foo", "= 1.0"
      end
      add_spec "bar", "1.1" do
        runtime "foo", "= 1.1"
      end
      add_spec "foo", "1.0"
      add_spec "foo", "1.1"
    end

    deps = [
      build_dep("bar", ">= 1.0"),
      build_dep("foo", "= 1.0"),
    ]

    solution = Bundler::Resolver.resolve(deps, [index])
    solution.should match_gems(
      "bar" => ["1.0"],
      "foo" => ["1.0"]
    )
  end

  it "supports merb-core" do
    index = Gem::SourceIndex.from_gems_in(gem_repo3.join("specifications"))

    deps = [
      build_dep("merb-core", "= 1.0.7.1"),
    ]

    solution = Bundler::Resolver.resolve(deps, [index])
    solution.should match_gems(
      "merb-core"=>["1.0.7.1"],
      "rake"=>["0.8.7"],
      "thor"=>["0.9.9"],
      "rspec"=>["1.2.2"],
      "mime-types"=>["1.16"],
      "abstract"=>["1.0.0"],
      "rack"=>["1.0.0"],
      "erubis"=>["2.6.4"],
      "extlib"=>["0.9.12"],
      "json_pure"=>["1.1.7"]
    )
  end

  it "supports impossible situations" do
    index = build_index do
      add_spec "a", "1.0"
    end

    deps = [
      build_dep("a", "= 1.1"),
    ]

    lambda { Bundler::Resolver.resolve(deps, [index]) }.should raise_error(Bundler::GemNotFound)
  end
end
