#!/usr/bin/ruby

require 'bdb1'
module BDB1
  class Bcomp < Btree
    extend Marshal

    def bdb1_bt_compare(a, b)
      a <=> b
    end
  end
end

record1Class = Struct.new('Record1', :f1, :f2 ,:f3)
record2Class = Struct.new('Record2', :f3, :f2 ,:f1)

File.delete('tmp/hash1.bdb') if File.exists?('tmp/hash1.bdb')

hash1 = BDB1::Bcomp.create('tmp/hash1.bdb', "w", 0644,
			  'set_pagesize' => 1024) 
f1 = 'aaaa'
f2 = 'lmno'
f3 = 'rrrr'
10000.times do |i|
  rec1 = record1Class.new
  rec1.f1 = f1 = f1.succ
  rec1.f2 = f2 = f2.succ
  rec1.f3 = f3 = f3.succ
  hash1[rec1.f1] = rec1 
end

File.delete('tmp/hash2.bdb') if File.exists?('tmp/hash2.bdb')

hash2 = BDB1::Bcomp.create('tmp/hash2.bdb', "w", 0644, 
			  'set_pagesize' => 1024)
hash1.each do |k,rec1|
  rec2 = record2Class.new
  rec2.f1 = rec1.f1
  rec2.f2 = rec1.f2
  rec2.f3 = rec1.f3
  hash2[rec2.f1] = rec2
  puts "Record2 #{hash2[rec2.f1].inspect}"
end
