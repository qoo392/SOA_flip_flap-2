# Module that can be included (mixin) to create and parse TSV data
module TsvBuddy
  # @data should be a data structure that stores information
  #  from TSV or Yaml files. For example, it could be an Array of Hashes.
  attr_accessor :data

  # take_tsv: converts a String with TSV data into @data
  # parameter: tsv - a String in TSV format
  def take_tsv(tsv)

    key_arr = tsv.split("\n")[0].split("\t")
    key_arr.map!{ |x| x.chomp } # Determine keys

    hash_stored = [] # store hash before to_yaml

    value_lines= tsv.split("\n")[1..-1]
    value_arr = value_lines.each do |line|
      value = line.split("\t")
      #value.map!(&:chomp)
      tsv_hash = {}
      key_arr.each_index { |index| tsv_hash[key_arr[index]] = value[index] }
      hash_stored << tsv_hash
      @data = hash_stored
      # key/value pair matching, set it equal to @data, the data structure
    end
  end

  # to_tsv: converts @data into tsv string
  # returns: String in TSV format
  def to_tsv
    keys = @data[0].keys
    keys_to_tsv = @data[0].keys.reduce { |key1, key2| key1 + "\t" + key2 } + "\r\n" #Use reduce to turn keys into tsv format

    value_to_tsv = @data.map.with_index { |hash, index| hash.values.reduce { |value1, value2| value1 + "\t" + value2 } }
    value_to_tsv.map! { |value| value + "\r\n"  }
    #1. Break the hash array into hash respectively
    #2. Call the value of each hash by "hash.values"
    #3. Use reduce to link each value with '\t' (tab)
    #4. Fulfill the format of tsv file (tab as seperator)
    #5. Add '\r\n' at the end of each value string
    return keys_to_tsv + value_to_tsv.join
  end
end
