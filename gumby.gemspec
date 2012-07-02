Gem::Specification.new do |gem|
  gem.authors       = ["Neil Mock"]
  gem.email         = ["neilmock@gmail.com"]
  gem.description   = "A query DSL for elasticsearch."
  gem.summary       = "A query DSL for elasticsearch."
  gem.homepage      = "https://github.com/neilmock/gumby"

  gem.files         = `git ls-files`.split "\n"
  gem.test_files    = `git ls-files -- test/*`.split "\n"
  gem.name          = "gumby"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.1"

  gem.required_ruby_version = ">= 1.9.2"
end
