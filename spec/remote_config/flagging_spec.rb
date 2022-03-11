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
              .and(having_attributes(key: key))
          )
      end
    end

    context "when the adapter returns true for the key" do
      before do
        allow(adapter_double).to receive(:fetch_feature_flag)
          .with(key).and_return(true)
      end

      it "returns true" do
        expect(instance.feature_enabled?(key)).to be(true)
      end

      it "yields a given block and returns true" do
        block_yielded = false
        return_value = instance.feature_enabled?(key) { block_yielded = true }

        expect(block_yielded).to be(true)
        expect(return_value).to be(true)
      end
    end

    context "when the adapter returns false for the key" do
      before do
        allow(adapter_double).to receive(:fetch_feature_flag)
          .with(key).and_return(false)
      end

      it "returns false" do
        expect(instance.feature_enabled?(key)).to be(false)
      end

      it "doesn't yield the given block and returns false" do
        block_yielded = false
        return_value = instance.feature_enabled?(key) { block_yielded = true }

        expect(block_yielded).to be(false)
        expect(return_value).to be(false)
      end
    end

    context "when the adapter returns a non-boolean value" do
      before do
        allow(adapter_double).to receive(:fetch_feature_flag)
          .with(key).and_return("alakazam")
      end

      it "raises a `RemoteConfig::NonBooleanFeatureFlagError`" do
        expect { instance.feature_enabled? key }
          .to raise_error(
            an_instance_of(RemoteConfig::NonBooleanFeatureFlagError)
              .and(having_attributes(key: key))
          )
      end
    end
  end

  describe "#released?" do
    # rubocop:disable Rails/Inquiry
    let(:key) { "hocus.pocus" }
    let(:adapter_double) { instance_double(RemoteConfig::Adapters::RubyConfigAdapter) }

    before do
      allow(RemoteConfig).to receive(:adapter).and_return(adapter_double)

      RemoteConfig.configure do |config|
        config.release_stages = {
          production:  %i[production uat development],
          uat:         %i[uat development],
          development: %i[development]
        }
      end
    end

    context "when the adapter cannot find a value for the key" do
      it "raises a `RemoteConfig::UnknownReleaseFlagError` error" do
        allow(adapter_double).to receive(:fetch_release_flag).with(key).and_return(nil)
        expect { instance.released? key }
          .to raise_error(
            an_instance_of(RemoteConfig::UnknownReleaseFlagError)
              .and(having_attributes(key: key))
          )
      end
    end

    context "when the current environment is in the flags current release stage" do
      before do
        allow(Rails).to receive(:env).and_return("development".inquiry)
        allow(adapter_double).to receive(:fetch_release_flag)
          .with(key).and_return("development")
      end

      it "returns true" do
        expect(instance.released?(key)).to be(true)
      end

      it "yields a given block and returns true" do
        block_yielded = false
        return_value = instance.released?(key) { block_yielded = true }

        expect(block_yielded).to be(true)
        expect(return_value).to be(true)
      end
    end

    context "when the current environment is not in the flags current release stage" do
      before do
        allow(Rails).to receive(:env).and_return("uat".inquiry)
        allow(adapter_double).to receive(:fetch_release_flag)
          .with(key).and_return("development")
      end

      it "returns false" do
        expect(instance.released?(key)).to be(false)
      end

      it "doesn't yield the given block and returns false" do
        block_yielded = false
        return_value = instance.released?(key) { block_yielded = true }

        expect(block_yielded).to be(false)
        expect(return_value).to be(false)
      end
    end

    context "when the flags current release stage not a recognised release stage" do
      it "raises a `RemoteConfig::UnkownReleaseStageError` error" do
        allow(adapter_double).to receive(:fetch_release_flag).with(key).and_return("misc")
        allow(Rails).to receive(:env).and_return("development".inquiry)

        expect { instance.released? key }
          .to raise_error(
            an_instance_of(RemoteConfig::UnknownReleaseStageError)
              .and(having_attributes(key: key, value: "misc"))
          )
      end
    end
    # rubocop:enable Rails/Inquiry
  end
end
