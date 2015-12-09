lines = File.readlines("oliver.txt")
line_count = lines.size
text = lines.join
puts "Analysis of 'oliver.txt':\n\n"
puts "#{line_count} lines"

total_characters = text.length
puts "#{total_characters} characters"

total_characters_nospaces = text.gsub(/\s+/, '').length
puts "#{total_characters_nospaces} characters excluding spaces"

word_count = text.split.length
puts "#{word_count} words"

stopwords = %w{the a by on for of are with just but and to the my I has some in}
words = text.scan(/\w+/)
keywords = words.select { |word| !stopwords.include?(word) }
keyword_count = keywords.length
puts "#{keyword_count} interesting words"
puts "#{((keyword_count.to_f / word_count.to_f)* 100).to_i}% of words are interesting"

sentence_count = text.split(/\.|\?|!/).length
puts "#{sentence_count} sentences"

paragraph_count = text.split(/\n\n/).length
puts "#{paragraph_count} paragraphs"

puts "#{word_count / sentence_count} words per sentence (average)"
puts "#{keyword_count / sentence_count} interesting words per sentence (average)"

puts "#{sentence_count / paragraph_count} sentences per paragraph (average)"  

puts "\n\nSummary:\n\n"
sentences = text.gsub(/\s+/, ' ').strip.split(/\.|\?|!/)
sentences_sorted = sentences.sort_by { |sentence| sentence.length }
one_third = sentences_sorted.length / 3
ideal_sentences = sentences_sorted.slice(one_third, one_third +1)
ideal_sentences = ideal_sentences.select { |sentence| sentence =~ /is|are/ }
puts ideal_sentences.join(". ")
puts "-- End of analysis"