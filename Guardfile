

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' }, :test_unit => false do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('spec/spec_helper.rb')
  watch(%r{^spec/support/.+\.rb$})
end


guard 'coffeescript', :output => 'public/javascripts/compiled' do
  watch(%r{^app\/coffeescripts\/(.*)\.coffee/})
end

guard 'coffeescript', :output => 'spec/javascripts' do
  watch(%r(^spec\/coffeescripts\/(.*)\.coffee))
end


guard 'livereload' do
  watch(%r{^spec\/javascripts\/.+\.js$})
  watch(%r{^public\/javascripts\/compiled\/.+\.js$})
end


guard 'cucumber', :cli => "--no-profile --drb --color --format progress", :all_on_start => false, :all_after_pass => false do
  watch(%r{^features\/.+\.feature$})
  watch(%r{^features\/support\/.+$})                      { 'features' }
  watch(%r{^features\/step_definitions\/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end


guard 'rspec', :version => 2, :cli => "--color --format nested --fail-fast --drb", :all_on_start => false, :all_after_pass => false do
  watch(%r{^spec\/.+_spec\.rb$})
  watch(%r{^lib\/(.+)\.rb$})      { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')    { "spec/" }

  # Rails example
  watch(%r{^spec\/.+_spec\.rb$})
  watch(%r{^app\/(.+)\.rb$})                              { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib\/(.+)\.rb$})                              { |m| "spec/lib/#{m[1]}_spec.rb" }
  # watch(%r{^app\/controllers\/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec\/support\/(.+)\.rb$})                    { "spec/" }
  watch('spec/spec_helper.rb')                            { "spec/" }
  # watch('config/routes.rb')                             { "spec/routing" }
  watch('app/controllers/application_controller.rb')      { "spec/controllers" }
  # Capybara request specs
  # watch(%r{^app\/views\/(.+)\/.*\.(erb|haml)$})         { |m| "spec/requests/#{m[1]}_spec.rb" }
end


guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end
