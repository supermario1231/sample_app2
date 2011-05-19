# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{arel}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Bryan Helmkamp}, %q{Nick Kallen}, %q{Emilio Tagua}]
  s.date = %q{2010-06-07}
  s.description = %q{Arel is a Relational Algebra for Ruby. It 1) simplifies the generation complex
of SQL queries and it 2) adapts to various RDBMS systems. It is intended to be
a framework framework; that is, you can build your own ORM with it, focusing on
innovative object and collection modeling as opposed to database compatibility
and query generation.}
  s.email = %q{bryan@brynary.com}
  s.extra_rdoc_files = [%q{History.txt}, %q{README.markdown}]
  s.files = [%q{History.txt}, %q{README.markdown}]
  s.homepage = %q{http://github.com/brynary/arel}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{arel}
  s.rubygems_version = %q{1.8.2}
  s.summary = %q{Arel is a relational algebra engine for Ruby}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0.0"])
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0.0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0.0"])
  end
end
