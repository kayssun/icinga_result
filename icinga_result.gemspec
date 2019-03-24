lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'icinga_result'
  spec.version       = '1.0.0'
  spec.authors       = ['Gerrit Visscher']
  spec.email         = ['gerrit@visscher.de']
  spec.summary       = 'A library to send passive check results to icinga via the API'
  spec.description   = 'This library send checks result to Icinga2 via the http api. It provides an executable to send result from shell scripts'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
end
