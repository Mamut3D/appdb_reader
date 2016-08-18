require 'spec_helper'

describe AppdbReader::CacheManager do
  before :example do
    allow(FileUtils).to receive(:mkdir_p)
  end

  subject { cache_manager }
  let(:cache_manager) { AppdbReader::CacheManager.new {logger: Logger.new('/dev/null')} }

  describe '#new' do
    it 'creates an instance of AppdbReader::CacheManager' do
      expect(subject).to be_instance_of AppdbReader::CacheManager
    end
  end

  describe '.cache_fetch' do
    let(:json) { {key: 'value'} }

    context 'with no block given' do
      it 'rises an exception' do
        expect {subject.cache_fetch}.to raise_error
      end
    end

    context 'with data in cache' do
      before :example do
          allow(File).to receive(:exist?).with(filename) { true }
          allow(File).to receive(:zero?).with(filename) { false }
          allow(File).to receive(:stat).with(filename) { stat }
          allow(stat).to receive(:mtime) { Time.now }
      end

      let(:filename) {'/tmp/guocci_cache/dummy-file'}
      let(:stat) { double('stat') }

      context 'which are expired' do
        it 'executes block and stores them to cache' do

        end
      end

      context 'which are up to date' do
        context 'but file is empty' do
          it 'executes block and stores them to cache' do

          end
        end

        context 'and file is not empty' do
          it 'loads data from cache' do
            expect(subject.cache_fetch('dummy-file') { 'block' }).to eq json
          end
        end
      end
    end

    context 'without data in cache' do
      it 'executes block and stores them to cache' do

      end
    end
  end
end
