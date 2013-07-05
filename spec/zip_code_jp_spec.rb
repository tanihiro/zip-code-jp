# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

describe ZipCodeJp do

  describe 'If you want to search from the zip code.' do
    it 'zip code exists.' do
      address = ZipCodeJp.find '152-0004'
      expect(address.prefecture).to eq('東京都')
      expect(address.prefecture_kana).to eq('トウキョウト')
      expect(address.prefecture_code).to eq(13)
      expect(address.city).to eq('目黒区')
      expect(address.city_kana).to eq('メグロク')
      expect(address.town).to eq('鷹番')
      expect(address.town_kana).to eq('タカバン')
    end

    it 'multi address zip code.' do
      addresses = ZipCodeJp.find '0790177'
      expect(addresses.class).to eq(Array)
      addresses.each do |address|
        expect(address.prefecture).to eq('北海道')
        expect(address.prefecture_kana).to eq('ホッカイドウ')
        expect(address.city).to eq('美唄市')
        expect(address.city_kana).to eq('ビバイシ')
        expect(address.town).to match(/上美唄町(協和|南)/)
        expect(address.town_kana).to match(/カミビバイチョウ(キョウワ|ミナミ)/)
        expect(address.prefecture_code).to eq(1)
      end
    end

    it 'zip code does not exists.' do
      address = ZipCodeJp.find '000-0000'
      expect(address).to eq(false)
    end
  end
end
