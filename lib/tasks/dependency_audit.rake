# frozen_string_literal: true
# Task created by secure_framework to audit dependencies.

require 'bundler/audit/database'
require 'bundler/audit/scanner'

namespace :dependency_audit do
  desc 'Scans dependencies for vulnerabilities'
  task check: :environment do
    puts "--> Updating vulnerability database..."
    Bundler::Audit::Database.update!(quiet: true)

    puts "--> Scanning Gemfile.lock for vulnerabilities..."
    scanner = Bundler::Audit::Scanner.new
    results = scanner.scan.to_a

    if results.any?
      puts "\n[!] VULNERABILITIES FOUND\n"
      results.each do |result|
        if result.is_a?(Bundler::Audit::Scanner::UnpatchedGem)
          puts "=============================================="
          puts "  Gem:         #{result.gem.name} (v#{result.gem.version})"
          puts "  Advisory:    #{result.advisory.title}"
          puts "  Criticality: #{result.advisory.criticality&.to_s&.upcase || 'UNKNOWN'}"
          puts "  URL:         #{result.advisory.url}"
          puts "  Solution:    Upgrade to version #{result.advisory.patched_versions.join(', ')}"
          puts "==============================================\n"
        end
      end
      # Abort with a non-zero exit code to fail CI builds
      abort("Action required: Insecure dependencies found.")
    else
      puts "\n[+] SUCCESS: No known vulnerabilities found."
    end
  end
end
