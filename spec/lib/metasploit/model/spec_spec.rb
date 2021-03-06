require 'spec_helper'

describe Metasploit::Model::Spec do
  before(:each) do
    @before_temporary_pathname = described_class.send(:remove_instance_variable, :@temporary_pathname)
  end

  after(:each) do
    described_class.instance_variable_set(:@temporary_pathname, @before_temporary_pathname)
  end

  context 'remove_temporary_pathname' do
    subject(:remove_temporary_pathname) do
      described_class.remove_temporary_pathname
    end

    let(:pathname) do
      Metasploit::Model.root.join('spec', 'pathname')
    end

    context 'with temporary_pathname set' do
      before(:each) do
        described_class.temporary_pathname = pathname
      end

      context 'that exists' do
        before(:each) do
          pathname.mkpath

          child_pathname = pathname.join('child')

          child_pathname.open('wb') do |f|
            f.puts 'Child File'
          end
        end

        it 'should remove file tree' do
          pathname.exist?.should be_true

          remove_temporary_pathname

          pathname.exist?.should be_false
        end
      end

      context 'that does not exist' do
        it 'should not raise an error' do
          expect {
            remove_temporary_pathname
          }.to_not raise_error
        end
      end
    end

    context 'without temporary_pathname set' do
      it 'should not error' do
        expect {
          remove_temporary_pathname
        }.to_not raise_error
      end
    end
  end

  context 'temporary_pathname' do
    subject(:temporary_pathname) do
      described_class.temporary_pathname
    end

    context 'with @temporary_pathname defined' do
      let(:pathname) do
        Metasploit::Model.root.join('spec', 'pathname')
      end

      before(:each) do
        described_class.temporary_pathname = pathname
      end

      it 'should not raise error' do
        expect {
          temporary_pathname
        }.to_not raise_error
      end

      it 'should return set pathname' do
        temporary_pathname.should == pathname
      end
    end

    context 'without @temporary_pathname defined' do
      it 'should raise Metasploit::Model::Spec::Error' do
        expect {
          temporary_pathname
        }.to raise_error(
                 Metasploit::Model::Spec::Error,
                 'Metasploit::Model::Spec.temporary_pathname not set prior to use'
             )
      end
    end
  end

  context 'temporary_pathname=' do
    let(:temporary_pathname) do
      Metasploit::Model.root.join('spec', 'temporary_pathname')
    end

    it 'should set @temporary_pathname' do
      expect {
        described_class.temporary_pathname = temporary_pathname
      }.to change {
        described_class.instance_variable_get(:@temporary_pathname)
      }.to(temporary_pathname)
    end
  end
end