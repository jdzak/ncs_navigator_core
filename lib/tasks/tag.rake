namespace :version do

  desc "Updates the application version file - #{Rails.root}/config/app_version.yml\n" +
       "Usage: rake version:tag TAG=1.2.3"
  task :tag do

    tag = ENV['TAG'] || NcsNavigator::Core::VERSION

    puts "About to tag version #{tag.inspect}"

    if tag.nil?
      puts "You must specify a tag in order to run this task."
      return
    elsif tag.include?('pre')
      puts "You cannot use a 'pre' tag for this task. Update the #{Rails.root}/lib/ncs_navigator/core/version.rb file."
      return
    end

    (major,minor,revision) = tag.split(/_|\./)
    app_version_file_path = "#{Rails.root}/config/app_version.yml"

    File.open(app_version_file_path, "w+") do |version_file|
      version_file.puts "# This file is automatically generated by the Tag rake task. rake version:tag TAG=1.2.3\n"
      version_file.puts "major: #{major}\n"
      version_file.puts "minor: #{minor}\n"
      version_file.puts "revision: #{revision}\n"
      version_file.puts "time: #{Time.now}\n"
    end

    `git commit -a -m "updated app_version.yml for tag: #{tag}"; git push; git tag -a #{tag} -m "version #{tag}"; git push --tags`
  end

end
