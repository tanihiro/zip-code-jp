# -*- coding: utf-8 -*-
require 'zipruby'
require 'json'
require 'open-uri'
require 'csv'
require 'nkf'
require 'yaml'

module ZipCodeJp
  class Export
    ZIP_URL  = 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip'
    DATA_DIR = File.dirname(__FILE__) + '/../../data'

    private
    def self.to_hash(row)
      {
        :zip_code        => row[2],
        :prefecture      => NKF.nkf('-S -w', row[6]),
        :prefecture_kana => NKF.nkf('-S -w', row[3]),
        :city            => NKF.nkf('-S -w', row[7]),
        :city_kana       => NKF.nkf('-S -w', row[4]),
        :town            => NKF.nkf('-S -w', row[8]).gsub(/(以下に掲載がない場合|（.*）)/, ''),
        :town_kana       => NKF.nkf('-S -w', row[5]).gsub(/(イカニケイサイガナイバアイ|\(.*\))/, '')
      }
    end

    private
    def self.zip_codes
      zip_codes = {}
      prefecture_codes = YAML.load(File.open("#{DATA_DIR}/prefecture_code.yml"))
      Zip::Archive.open(open(ZIP_URL).path) do |archives|
        archives.each do |a|
          CSV.parse(a.read) do |row|
            h = to_hash(row)
            h[:prefecture_code] = prefecture_codes.invert[h[:prefecture]]
            prefix = h[:zip_code].slice(0,3)
            zip_codes[prefix] = {} unless zip_codes[prefix]
            zip_codes[prefix] = zip_codes[prefix].merge({h[:zip_code].slice(3,4) => h})
          end
        end
      end
      zip_codes
    end

    def self.execute
      zip_codes().each do |prefix, value|
        file_path = "#{DATA_DIR}/zip_code/#{prefix}.json"
        File.open(file_path, 'wb') do |file|
          file.write JSON.generate(value)
        end
      end
    end
  end
end
