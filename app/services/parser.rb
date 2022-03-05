class Parser
  UNWANTED_WORDS = %w[de la en le dans les et tu pour des une un est pas ton sur va qui on que te par avec tes bien du il qu ils ta ne peux nous si cette tout]
  
  def cleanup_string(string)
    cleaned_string = []
    string.split(/ |'/) do |word|
      word = word.downcase.delete('.,:;()!?$=<%>"')
      next if word.length < 2
      next if UNWANTED_WORDS.include? word
      next unless word.ascii_only?
      cleaned_string << word
    end
    cleaned_string.join(" ")
  end
  
end