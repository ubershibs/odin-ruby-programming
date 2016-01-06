require 'jumpstart_auth'
require 'bitly'
require 'klout'


class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter  
    Bitly.use_api_version_3
    Klout.api_key = 'xu9ztgnacmjx3bu82warbr3h'
  end

  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ""
    while command != "q"
      printf "Enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" ")) 
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'spam' then spam_my_followers(parts[1..-1].join(" "))
        when 'elt' then everyones_last_tweet
        when 's' then shorten(parts[1..-1].join(" "))
        when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
        when 'k' then klout_score
        else 
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end

  def tweet(message)
    if message.length <= 140
      @client.update(message) 
    else
      puts "Your message is too long - #{message.length}"
    end
  end

  def dm(target, message)
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }

    if screen_names.include?(target)
      puts "Trying to send #{target} this direct message."
      puts message
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "You can only DM people you follow."
    end
  end

  def followers_list
    screen_names = Array.new
    @client.followers.each do |follower|
      screen_names << @client.user(follower).screen_name
    end
    screen_names
  end

  def spam_my_followers(message)
    screen_names = followers_list
    screen_names.each { |follower| dm(follower, message) }
  end

  def everyones_last_tweet
    friends = @client.friends
    friends = friends.sort_by { |friend| @client.user(friend).screen_name.downcase }
    
    friends.each do |friend|
      friend_data = @client.user(friend)
      screen_name = friend_data.screen_name
      last_tweet = friend_data.status.text
      created_at = friend_data.status.created_at.strftime("%A, %b %d")
      puts "#{screen_name} tweeted this at #{created_at}:"
      puts last_tweet
    end
  end

  def shorten(original_url)
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    short_url = bitly.shorten(original_url).short_url
    puts "Shortening this URL: #{original_url}"
    puts "Short URL is: #{short_url}"
    return short_url
  end

  def klout_score
    friends = @client.friends.collect {|f| @client.user(f).screen_name}
    friends.each do |friend|
      identity = Klout::Identity.find_by_screen_name(friend)
      user = Klout::User.new(identity.id)
      user.score.score
      puts "#{friend}: #{user.score.score}"
    end
  end
end


blogger = MicroBlogger.new
blogger.run