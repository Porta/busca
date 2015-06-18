# encoding: utf-8

Gem::Specification.new do |s|
  s.name              = "busca"
  s.version           = "0.0.1"
  s.summary           = "Busca is a simple redis search"
  s.description       = "Busca is a simple redis search that uses bitmaps to index words"
  s.authors           = ["Julián Porta"]
  s.email             = ["julian@porta.sh"]
  s.homepage          = "https://github.com/Porta/busca"
  s.files             = `git ls-files`.split("\n")
  s.add_development_dependency "cutest", '~>1.2'
  s.add_runtime_dependency "redic", '~> 1.4'
  s.add_runtime_dependency "msgpack", '~> 0.5'
  s.add_runtime_dependency "filtra", '~> 0.0.1'
  s.add_runtime_dependency "separa", '~> 0.0.2'
  s.license           = "MIT"
end
