# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemoteConfig::Flagging do
  subject :instance do
    test_class.new
  end

  let :test_class do
    Class.new do
      include RemoteConfig::Flagging
    end
  end

  describe "#feature_enabled?" do
    let(:key) { "hocus.pocus" }
    let(:adapter_double) { instance_double(RemoteConfig::Adapters::RubyConfigAdapter) }

    before do
      allow(RemoteConfig).to receive(:adapter).and_return(adapter_double)
    end

    context "when the adapter cannot find a value for the key" do
      it "raises a `RemoteConfig::UnknownFeatureFlagError` error" do
        allow(adapter_double).to receive(:fetch_feature_flag).with(key).and_return(nil)
        expect { instance.feature_enabled? key }
          .to raise_error(
            an_instance_of(RemoteConfig::UnknownFeatureFlagError)
              .and having_attributes(key: key)
          )
      end
    end

    context "when the adapter finds a value for the key" do
      it "returns true when the adapter returns true" do
        allow(adapter_double).to receive(:fetch_feature_flag).with(key).and_return(true)
        expect(instance.feature_enabled? key).to be(true)
      end

      it "returns false when the adapter returns false" do
        allow(adapter_double).to receive(:fetch_feature_flag).with(key).and_return(false)
        expect(instance.feature_enabled? key).to be(false)
      end

      it "raises a `RemoteConfig::NonBooleanFeatureFlagError` when the adapter doesn't return a boolean" do
        allow(adapter_double).to receive(:fetch_feature_flag).with(key).and_return("alakazam")
        expect { instance.feature_enabled? key }
          .to raise_error(
            an_instance_of(RemoteConfig::NonBooleanFeatureFlagError)
              .and having_attributes(key: key)
          )
      end
    end
  end

  describe "#released?" do
    let(:key) { "hocus.pocus" }
    let(:adapter_double) { instance_double(RemoteConfig::Adapters::RubyConfigAdapter) }
    let(:release_stages) do
      {
        production:  %i[production uat development],
        uat:         %i[uat development],
        development: %i[development]
      }
    end

    before do
      allow(RemoteConfig).to receive(:adapter).and_return(adapter_double)

      RemoteConfig.configure do |config|
        config.release_stages = release_stages
      end
    end

    context "when the adapter cannot find a value for the key" do
      it "raises a `RemoteConfig::UnknownReleaseFlagError` error" do
        allow(adapter_double).to receive(:fetch_release_flag).with(key).and_return(nil)
        expect { instance.released? key }
          .to raise_error(
            an_instance_of(RemoteConfig::UnknownReleaseFlagError)
              .and having_attributes(key: key)
          )
      end
    end

    context "when the current environment is in the flags current release stage" do
      it "returns true" do
        allow(adapter_double).to receive(:fetch_release_flag).with(key).and_return("development")
        allow(Rails).to receive(:env).and_return("development".inquiry)

        expect(instance.released? key).to be(true)
      end
    end

    context "when the current environment is not in the flags current release stage" do
      it "returns false" do
        allow(adapter_double).to receive(:fetch_release_flag).with(key).and_return("development")
        allow(Rails).to receive(:env).and_return("uat".inquiry)

        expect(instance.released? key).to be(false)
      end
    end
  end
end

