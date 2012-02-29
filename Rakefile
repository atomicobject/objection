PROJECT_NAME = "Objection"
CONFIGURATION = "Debug"
SPECS_TARGET_NAME = "Specs-OSX"
UI_SPECS_TARGET_NAME = "Specs-iOS"
SDK_DIR = "/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator5.0.sdk"

def xcodebuild_executable
  "/Developer/usr/bin/xcodebuild"  
end

def build_dir(effective_platform_name)
  File.join(File.dirname(__FILE__), "build", CONFIGURATION + effective_platform_name)
end

def system_or_exit(cmd, stdout = nil)
  puts "Executing #{cmd}"
  cmd += " >#{stdout}" if stdout
  system(cmd) or raise "******** Build failed ********"
end

task :default => ["specs:ios", "specs:osx"]
task :cruise do
  Rake::Task[:clean].invoke
  Rake::Task[:build_all].invoke
  Rake::Task[:specs].invoke
  Rake::Task[:uispecs].invoke
end

namespace :artifact do
  desc "Build OSX Framework"
  task :osx => :clean do
    system_or_exit(%Q[#{xcodebuild_executable} -project #{PROJECT_NAME}.xcodeproj -target Objection -configuration Release build], nil)
  end
  
  desc "Build iOS Framework"
  task :ios  => :clean do
    system_or_exit(%Q[#{xcodebuild_executable} -project #{PROJECT_NAME}.xcodeproj -target Objection-iOS -configuration Release build], nil)
  end                             
  
  require 'rake/clean'
  CLEAN.include("pkg")
  CLEAN.include("build")
  
  desc "Build package containing OS X and iOS frameworks"
  task :package => [:clean, :osx, :ios] do    
    version = %x|/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" Objection-Info.plist|.strip
    mkdir_p "pkg"
    cp_r "build/Release-iphoneuniversal/Objection-iOS.framework", "pkg"
    cp_r "build/Release/Objection.framework", "pkg"
    cd "pkg" do
      sh "tar cvzf Objection-#{version}.tar.gz Objection-iOS.framework Objection.framework"
    end
  end
end
  
task :clean do
  stdout = File.join(ENV['CC_BUILD_ARTIFACTS'], "clean.output") if (ENV['IS_CI_BOX'])
  system_or_exit(%Q[#{xcodebuild_executable} -project #{PROJECT_NAME}.xcodeproj -alltargets -configuration #{CONFIGURATION} clean], stdout)
end

task :build_all do
  stdout = File.join(ENV['CC_BUILD_ARTIFACTS'], "build_all.output") if (ENV['IS_CI_BOX'])
  system_or_exit(%Q[#{xcodebuild_executable} -project #{PROJECT_NAME}.xcodeproj -alltargets -configuration #{CONFIGURATION} build], stdout)
end

namespace :specs do
  desc "All Specs"
  task :all => [:osx, :ios]

  desc "OS X Specs"
  task :osx do
    stdout = File.join(ENV['CC_BUILD_ARTIFACTS'], "build_specs.output") if (ENV['IS_CI_BOX'])
    system_or_exit(%Q[#{xcodebuild_executable} -project #{PROJECT_NAME}.xcodeproj -target #{SPECS_TARGET_NAME} -configuration #{CONFIGURATION} build], stdout)
  end

  desc "iOS Specs"
  task :ios do
    stdout = File.join(ENV['CC_BUILD_ARTIFACTS'], "build_uispecs.output") if (ENV['IS_CI_BOX'])
    system_or_exit(%Q[#{xcodebuild_executable} -project #{PROJECT_NAME}.xcodeproj -target #{UI_SPECS_TARGET_NAME} -sdk #{SDK_DIR} -configuration #{CONFIGURATION} build], stdout)
  end
end
