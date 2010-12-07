PROJECT_NAME = "Objection"
CONFIGURATION = "Debug"
SPECS_TARGET_NAME = "Specs"
UI_SPECS_TARGET_NAME = "UISpecs"
SDK_DIR = "/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator4.2.sdk"

def build_dir(effective_platform_name)
  File.join(File.dirname(__FILE__), "build", CONFIGURATION + effective_platform_name)
end

def system_or_exit(cmd, stdout = nil)
  puts "Executing #{cmd}"
  cmd += " >#{stdout}" if stdout
  system(cmd) or raise "******** Build failed ********"
end

task :default => [:specs, :uispecs]
task :cruise do
  Rake::Task[:clean].invoke
  Rake::Task[:build_all].invoke
  Rake::Task[:specs].invoke
  Rake::Task[:uispecs].invoke
end

task :clean do
  stdout = File.join(ENV['CC_BUILD_ARTIFACTS'], "clean.output") if (ENV['IS_CI_BOX'])
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -alltargets -configuration #{CONFIGURATION} clean], stdout)
end

task :build_specs do
  stdout = File.join(ENV['CC_BUILD_ARTIFACTS'], "build_specs.output") if (ENV['IS_CI_BOX'])
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{SPECS_TARGET_NAME} -configuration #{CONFIGURATION} build], stdout)
end

task :build_uispecs do
  stdout = File.join(ENV['CC_BUILD_ARTIFACTS'], "build_uispecs.output") if (ENV['IS_CI_BOX'])
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -target #{UI_SPECS_TARGET_NAME} -configuration #{CONFIGURATION} build], stdout)
end

task :build_all do
  stdout = File.join(ENV['CC_BUILD_ARTIFACTS'], "build_all.output") if (ENV['IS_CI_BOX'])
  system_or_exit(%Q[xcodebuild -project #{PROJECT_NAME}.xcodeproj -alltargets -configuration #{CONFIGURATION} build], stdout)
end

task :specs => :build_specs do
  build_dir = build_dir("")
  ENV["DYLD_FRAMEWORK_PATH"] = build_dir
  system_or_exit(File.join(build_dir, SPECS_TARGET_NAME))
end

require 'tmpdir'
task :uispecs => :build_uispecs do
  ENV["DYLD_ROOT_PATH"] = SDK_DIR
  ENV["IPHONE_SIMULATOR_ROOT"] = SDK_DIR
  ENV["CFFIXED_USER_HOME"] = Dir.tmpdir
  ENV["CEDAR_HEADLESS_SPECS"] = "1"

  system_or_exit(%Q[#{File.join(build_dir("-iphonesimulator"), "#{UI_SPECS_TARGET_NAME}.app", UI_SPECS_TARGET_NAME)} -RegisterForSystemEvents]);
end

desc "Run the Clang static analyzer against the codebase"
task :clang do
  raise 'No "scan-build" found, you need Clang: http://clang-analyzer.llvm.org' unless
    File.exist?(`which scan-build`.strip)
  system "xcodebuild -configuration Debug -sdk iphonesimulator4.2 -target Objection-StaticLib clean"
  sh "scan-build -k -V xcodebuild -configuration Debug -sdk iphonesimulator4.2 -target Objection-StaticLib"
end
