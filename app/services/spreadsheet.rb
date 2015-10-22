class Spreadsheet
  def initialize(file)
    if File.exist?(file)
      @file = Roo::Spreadsheet.open(file)
    end
  end

  def import(class_name, args={})
    obj = class_name.constantize
    records = []
    @file.each_with_pagename do |name, sheet|
      headers = sheet.row(1)
      (2..sheet.last_row).each do |i|
        row = Hash[[headers, sheet.row(i)].transpose]
        row.delete_if {|key, value| key.nil? }
        records << row
      end
    end
    records.each do |record|
      if record.has_key?(:id)
        instance = obj.find(record[:id])
        instance.attributes = record
        instance.save if instance.valid?
      elsif args.count > 0
        instance = obj.new(record)
        args.each do |k, v|
          args.delete(k) unless instance.has_attribute?(k)
        end
        instance.attributes = args
        instance.save if instance.valid?
      else  
        instance = obj.find_or_create_by(record)
      end
    end
  end
end