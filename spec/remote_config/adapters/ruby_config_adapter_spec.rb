# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemoteConfig::Adapters::RubyConfigAdapter do
  subject(:adapter) do
    described_class.new({
      const_name:        "Settings",
      feature_flags_key: "feature_flags",
      release_flags_key: "release_flags"
    })
  end

  let(:settings_class) { Class.new }

  before do
    stub_const("Settings", Config::Options.new.tap do |options|
      options.add_source!({
        "feature_flags" => {
          "hocus" => {
            "_"     => true,
            "pocus" => {
              "alakazam"    => true,
              "smellakazam" => false
            }
          }
        },
        "release_flags" => {
          "tomatoes" => {
            "_"      => true,
            "canned" => {
              "diced" => true,
              "whole" => false
            }
          }
        }
      })
      options.reload!
    end)
  end

  describe "#fetch_feature_flag" do
    it "returns nil when the key is missing" do
      expect(adapter.fetch_feature_flag("null")).to be(nil)
      expect(adapter.fetch_feature_flag("hocus.null")).to be(nil)
      expect(adapter.fetch_feature_flag("hocus.pocus.alakazam.null")).to be(nil)
    end

    it "returns the value of the key when present" do
      expect(adapter.fetch_feature_flag("hocus.pocus.alakazam")).to be(true)
      expect(adapter.fetch_feature_flag("hocus.pocus.smellakazam")).to be(false)
    end

    it "returns the _ value of a found hash when present" do
      expect(adapter.fetch_feature_flag("hocus")).to be(true)
    end

    it "returns nil when the _ value is missing from a found hash" do
      expect(adapter.fetch_feature_flag("hocus.pocus")).to be(nil)
    end
  end

  describe "#fetch_release_flag" do
    it "returns nil when the key is missing" do
      expect(adapter.fetch_release_flag("null")).to be(nil)
      expect(adapter.fetch_release_flag("tomatoes.null")).to be(nil)
      expect(adapter.fetch_release_flag("tomatoes.canned.diced.null")).to be(nil)
    end

    it "returns the value of the key when present" do
      expect(adapter.fetch_release_flag("tomatoes.canned.diced")).to be(true)
      expect(adapter.fetch_release_flag("tomatoes.canned.whole")).to be(false)
    end

    it "returns the _ value of a found hash when present" do
      expect(adapter.fetch_release_flag("tomatoes")).to be(true)
    end

    it "returns nil when the _ value is missing from a found hash" do
      expect(adapter.fetch_release_flag("tomatoes.canned")).to be(nil)
    end
  end
end
