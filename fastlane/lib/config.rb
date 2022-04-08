module Config
  module Keys
    BUILD_NUMBER_OFFSET = "build_number_offset"
    ID = "id"
    NAME = "name"
    APPCENTER_TARGET = "appcenter_target"
    APPCENTER_TOKEN = "appcenter_token"
    KEY_ALIAS = "key_alias"
    PROVISIONING_PROFILE_PATH = "provisioning_profile_path"
    PROVISIONING_PROFILE_NAME = "provisioning_profile_name"
    CERTIFICATE_NAME = "certificate_name"
    PROVISIONING_PROFILES = "provisioning_profiles"
    ADHOC = "adhoc"
  end

  module Platforms
    ANDROID = "android"
    IOS = "ios"
  end

  module Flavors
    PRODUCTION = "production"
  end

  module AndroidOutputs
    APK = "apk"
    APP_BUNDLE = "appbundle"
  end

  module BuildTypes
    DEBUG = "debug"
    RELEASE = "release"
  end

  ###
  ### All possible options should be described in this module
  ###
  module Options
    def self.doc_ANDROID_OUTPUT() "apk, appbundle" end
    ANDROID_OUTPUT = :android_output

    BUILD_NUMBER = :build_number

    def self.doc_CLEAN() "true, false" end
    CLEAN = :clean

    def self.doc_FLAVOR() "production" end
    FLAVOR = :flavor

    def self.doc_PLATFORM() "ios, android" end
    PLATFORM = :platform

    def self.doc_BUILD_TYPE() "debug, release" end
    BUILD_TYPE = :build_type

    def self.doc_UPLOAD_TO_APPCENTER() "true, false" end
    UPLOAD_TO_APPCENTER = :upload_to_appcenter

    def self.doc_STORE() "true, false" end
    STORE = :store

    VERSION_NAME = :version_name

    def self.doc_WATCH() "true, false" end
    WATCH = :watch

    def self.doc_TEST() "true, false" end
    TEST = :test

    def self.help()
      Options.constants.map { |o|
        doc = ""
        begin
          method = Options.method("doc_#{o.to_s}".to_sym)
          doc = ": [#{method.call}]" if method
        rescue
        end
        " - #{Options.const_get(o).to_s} #{doc}\n"
      }.reduce("", :+)
    end
  end

  # Options not passed by the user to a lane
  module InternalOptions
    ENV = :env
  end

  # env defaults that will be used when no ENV variables are provided
  ENV_DEFAULTS = {  }

  FLAVOR_MATRIX = {
    Flavors::PRODUCTION => {
      Platforms::IOS => {
        Keys::ID => "de.halfreal.blitzidea",
        Keys::NAME => "Flash Idea",
        Keys::APPCENTER_TARGET => "",
        Keys::APPCENTER_TOKEN => "APPCENTER_IOS_TOKEN",
      },
      Platforms::ANDROID => {
        Keys::ID => "de.halfreal.blitzidea",
        Keys::NAME => "Flash Idea",
        Keys::APPCENTER_TARGET => "",
        Keys::APPCENTER_TOKEN => "APPCENTER_ANDROID_TOKEN",
      },
    },
  }

  ANDROID_BUILD_CONFIG = {
    Flavors::PRODUCTION => {
      Keys::KEY_ALIAS => "release",
    },
  }

  IOS_BUILD_CONFIG = {
    Flavors::PRODUCTION => {
      Keys::PROVISIONING_PROFILE_PATH => "profiles/Flash_Idea_AppStore_Profile.mobileprovision",
      Keys::PROVISIONING_PROFILE_NAME => "Flash Idea AppStore Profile",
      Keys::CERTIFICATE_NAME => "Apple Distribution: Simon Joecks, Martin Nonnenmacher und Christian Paulus (DTM99KQJ5B)",
      Keys::PROVISIONING_PROFILES => {
        "de.halfreal.blitzidea" => "Flash Idea AppStore Profile",
      },
      Keys::ADHOC => false,
    },
  }

  # Appcenter defaults
  APPCENTER_OWNER_NAME = ""
  APPCENTER_OWNER_TYPE = "organization"
  APPCENTER_DESTINATION_TYPE_STORE = "store"
  APPCENTER_DEFAULT_TARGET = "Collaborators"
  APPCENTER_DEFAULT_STORE = "Beta"
end
