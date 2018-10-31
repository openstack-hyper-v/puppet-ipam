require 'spec_helper_acceptance'

describe 'ipam::install class' do
  describe 'running puppet code' do
    it 'might work with no errors' do
      pp = <<-EOS
      class{'ipam::install':

      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
