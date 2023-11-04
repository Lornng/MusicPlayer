require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Albums
    attr_accessor :artist, :title, :artwork, :tracks , :id1

    def initialize (artist, title, artwork, tracks, id1)
          @artist = artist
          @title = title
          @artwork = artwork
          @tracks = tracks
          @id1 = id1
    end
end

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

class Track
	attr_accessor :name, :location, :id2

	def initialize (name, location, id2)
		@name = name
		@location = location
    @id2 = id2
	end
end
# Put your record definitions here

class MusicPlayerMain < Gosu::Window

	def initialize
      #when click into the album
      @entire1 = false
      @entire2 = false
      @entire3 = false
      @entire4 = false
      super 900, 700
	    self.caption = "Jian Jia's Music Player"
      music_file = File.new("albums.txt", "r")
      @background = BOTTOM_COLOR
      @font_color = TOP_COLOR
      @track_font = Gosu::Font.new(30)
      @info_font = Gosu::Font.new(25)
      @albums = read_albums(music_file)
      @stop = false
      @pause = false
      @album_playing = 0
      @track_playing = 0
      @locs = [60, 60]
		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal111111
	end

  # Put in your code here to load albums and tracks
  def read_albums(music_file)
    count = music_file.gets().to_i
    albums = Array.new()
    i = 0
    while i < count
      album = read_album(music_file, i)
      albums << album
      i += 1
    end
    return albums
  end

  def read_album(music_file, i)
    album_artist = music_file.gets().chomp
    album_title  = music_file.gets().chomp
    album_artwork = music_file.gets().chomp
    album_id1 = i
    tracks = read_tracks(music_file)
    Albums.new(album_artist, album_title, album_artwork, tracks, album_id1)#s
  end

  def read_tracks(music_file)
    count = music_file.gets().to_i
    tracks = Array.new()

    i = 0
    while i < count
        track = read_track(music_file, i)
        tracks << track
        i += 1
    end
    return tracks
  end

  def read_track(music_file, i)
    track_name = music_file.gets().chomp
    track_location = music_file.gets().chomp
    track_id2 = i
    Track.new(track_name, track_location, track_id2)
  end
  # Draws the artwork on the screen for all the albums

  def draw_albums albums
    # complete this code
	  @bmp = Gosu::Image.new(albums[0].artwork)
	  @bmp.draw(40, 100, ZOrder::TOP)

    @bmp = Gosu::Image.new(albums[1].artwork)
	  @bmp.draw(40, 350, ZOrder::TOP)

    @bmp = Gosu::Image.new(albums[2].artwork)
	  @bmp.draw(290, 100, ZOrder::TOP)

    @bmp = Gosu::Image.new(albums[3].artwork)
	  @bmp.draw(290, 350, ZOrder::TOP)
  end

  def draw_button ()
    @bmp = Gosu::Image.new("images/stop.jpg")
    @bmp.draw(300, 600 , ZOrder::TOP)

    @bmp = Gosu::Image.new("images/pause.jpg")
    @bmp.draw(400, 600 , ZOrder::TOP)

    @bmp = Gosu::Image.new("images/play.jpg")
    @bmp.draw(500, 600 , ZOrder::TOP)

    @bmp = Gosu::Image.new("images/forward.jpg")
    @bmp.draw(600, 600 , ZOrder::TOP)
  end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked1(mouse_x, mouse_y)
     # complete this code
     if((mouse_x >= 40 and mouse_x <= 240) and (mouse_y >= 100 and mouse_y <= 300))
      true
     else
      false
     end
  end
  def area_clicked2(mouse_x, mouse_y)
     if ((mouse_x >= 40 and mouse_x <= 240) and (mouse_y >= 350 && mouse_y <= 550))
      true
     else
      false
     end
  end
  def area_clicked3(mouse_x, mouse_y)
     if ((mouse_x >= 290 and mouse_x <= 490) and (mouse_y >= 100 && mouse_y <= 300))
      true
     else
      false
     end
  end
  def area_clicked4(mouse_x, mouse_y)
     if ((mouse_x >= 290 and mouse_x <= 490) and (mouse_y >= 350 && mouse_y <= 550))
      true
     else
      false
     end
  end
  def area_clicked5(mouse_x, mouse_y)
    if ((mouse_x >= 600 and mouse_x <= 700) and (mouse_y >= 155 && mouse_y <= 175))
      @entire1 = true
      @track_playing = 0
      playTrack(@track_playing, @albums)
    else
     false
    end
 end

  def area_clicked_button(mouse_x, mouse_y)
    #stop button
    if ((mouse_x >= 300 && mouse_x <= 375) and (mouse_y >=600 && mouse_y <= 675))
      @stop = true
      @song.stop
      #to turn pause button to false back
      @pause = false
    else
      false
    end
    #pause button
    if ((mouse_x >= 400 && mouse_x <= 475) and (mouse_y >=600 && mouse_y <= 675))
      @pause = true
      @song.pause
      #to turn stop button to false back
      @stop = false
    else
      false
    end
    #play button
    if ((mouse_x >= 500 && mouse_x <= 575) and (mouse_y >=600 && mouse_y <= 675))
      @song.play
      @stop = false
    else
      false
    end
    #next button
    if ((mouse_x >= 600 && mouse_x <= 675) and (mouse_y >=600 && mouse_y <= 675))
      @stop = false
      @pause = false
      #following loop not working
      if(@track_playing == nil )
         @track_playing = 0
         playTrack(@track_playing, @albums)
      end
      #draw function it wont stop printing
      #stop the song
      #then only increment by 1
      #but because if continue to increment there's no info so it shows ntg
      @song.stop
      @track_playing += 1
      playTrack(@track_playing, @albums)
    end
  end

  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(albums, xpos = 600, ypos = 100)
    if @entire1 == true
      @track_font.draw_text("Album: #{albums[0].title}", xpos, ypos , ZOrder::TOP, 1.0, 1.0, @font_color)
      count = albums[0].tracks.length
      i = 0
      while i < count
        @track_font.draw_text(albums[0].tracks[i].name, xpos , ypos + 50 , ZOrder::TOP, 1.0, 1.0, @font_color)
        ypos += 70
        i += 1
      end
    end

    if @entire2 == true
      @track_font.draw_text("Album: #{albums[1].title}", xpos, ypos , ZOrder::TOP, 1.0, 1.0, @font_color)
      count = albums[1].tracks.length
      i = 0
      while i < count
        @track_font.draw_text(albums[1].tracks[i].name, xpos , ypos + 50 , ZOrder::TOP, 1.0, 1.0, @font_color)
        ypos += 70
        i += 1
      end
    end

    if @entire3 == true
      @track_font.draw_text("Album: #{albums[2].title}", xpos, ypos , ZOrder::TOP, 1.0, 1.0, @font_color)
      count = albums[2].tracks.length
      i = 0
      while i < count
        @track_font.draw_text(albums[2].tracks[i].name, xpos, ypos + 50 , ZOrder::TOP, 1.0, 1.0, @font_color)
        ypos += 70
        i += 1
      end
    end

    if @entire4 == true
      @track_font.draw_text("Album: #{albums[3].title}", xpos, ypos , ZOrder::TOP, 1.0, 1.0, @font_color)
      count = albums[3].tracks.length
      i = 0
      while i < count
        @track_font.draw_text(albums[3].tracks[i].name, xpos, ypos + 50 , ZOrder::TOP, 1.0, 1.0, @font_color)
        ypos += 70
        i += 1
      end
    end
  end

  def current_track_name(track, albums)
    if @entire1 == true
    @info_font.draw_text("Now playing: ", 600, 500, ZOrder::TOP, 1.0, 1.0, @font_color)
    @info_font.draw_text("#{albums[0].tracks[track].name}", 600, 525, ZOrder::TOP, 1.0, 1.0, Gosu::Color::YELLOW)

    end

    if @entire2 == true
      @info_font.draw_text("Now playing: ", 600, 500, ZOrder::TOP, 1.0, 1.0, @font_color)
      @info_font.draw_text("#{albums[1].tracks[track].name}", 600, 525, ZOrder::TOP, 1.0, 1.0, Gosu::Color::YELLOW)
    end

    if @entire3 == true
      @info_font.draw_text("Now playing: ", 600, 500, ZOrder::TOP, 1.0, 1.0, @font_color)
      @info_font.draw_text("#{albums[2].tracks[track].name}", 600, 525, ZOrder::TOP, 1.0, 1.0, Gosu::Color::YELLOW)
    end

    if @entire4 == true
      @info_font.draw_text("Now playing: ", 600, 500, ZOrder::TOP, 1.0, 1.0, @font_color)
      @info_font.draw_text("#{albums[3].tracks[track].name}", 600, 525, ZOrder::TOP, 1.0, 1.0, Gosu::Color::YELLOW)
    end
  end

  # Takes a track index and an Album and plays the Track from the Album

  def playTrack(track, albums)
  	 # complete the missing code
     # to prevent the code dying after the last track was played
     if (track < albums[0].tracks.length)
      if @entire1 == true
  		  @song = Gosu::Song.new(albums[0].tracks[track].location)
  		  @song.play(false)
      end
    else
      false
    end
    if (track < albums[1].tracks.length)
     if @entire2 == true
      @song = Gosu::Song.new(albums[1].tracks[track].location)
      @song.play(false)
     end
    else
      false
    end
    if (track < albums[2].tracks.length)
      if @entire3 == true
        @song = Gosu::Song.new(albums[2].tracks[track].location)
        @song.play(false)
      end
    else
      false
    end
    if (track < albums[3].tracks.length)
      if @entire4 == true
        @song = Gosu::Song.new(albums[3].tracks[track].location)
        @song.play(false)
      end
    else
      false
    end

     # Uncomment the following and indent correctly:
  	#	end
  	# end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background()
        Gosu.draw_rect(0, 0, 900, 700, @background, ZOrder::BACKGROUND, mode=:default)
	end

# Not used? Everything depends on mouse actions.

	def update
    if (@song)
      #7.3 continue with this part !!!!!!!!!!!!!!!!!!!!!!!!!!
      # i = 0
      # while(i < @albums.tracks.length)
      #   if (@albums.tracks[i].id2 = @track_playing)
      #     @font_color = Gosu::Color::YELLOW
      #   end
      #   i += 1
      # end
      #loop the songs after the 1st song finished
      if (!@song.playing? && @stop == false && @pause == false)
        @track_playing += 1
        playTrack(@track_playing, @albums)

      end
    end
	end
 # Draws the album images and the track list for the selected album

	def draw
		# Complete the missing code
    draw_background()
		draw_albums(@albums)
    draw_button()
    @info_font.draw("mouse_x: #{mouse_x}", 40, 625, ZOrder::TOP, 1.0, 1.0 , @font_color )
    @info_font.draw("mouse_y: #{mouse_y}", 40, 650, ZOrder::TOP, 1.0, 1.0 , @font_color )

    if (@song != nil && @song.playing? == true or @pause == true ) #same as !@song
      display_track(@albums)
      current_track_name(@track_playing, @albums)
    elsif (!@song or !@pause or @stop == true)
      @info_font.draw("Jian Jia's Music Albums:", 600, 100, ZOrder::TOP, 1.0, 1.0 , @font_color )
      @track_font.draw("Divide", 600, 150, ZOrder::TOP, 1.0, 1.0, Gosu::Color::AQUA)
      @track_font.draw("Nine Track Mind", 600, 200, ZOrder::TOP, 1.0, 1.0, Gosu::Color::AQUA)
      @track_font.draw("Purpose", 600, 250, ZOrder::TOP, 1.0, 1.0, Gosu::Color::AQUA)
      @track_font.draw("V", 600, 300, ZOrder::TOP, 1.0, 1.0, Gosu::Color::AQUA)
      #next button keeps '+1'
      @track_playing = -1
    end
	end

 	def needs_cursor?; true; end

	def button_down(id)
		case id
	    when Gosu::MsLeft
	    	# What should happen here?
        if area_clicked1(mouse_x, mouse_y)
          @entire1 = true
          @entire2 = false
          @entire3 = false
          @entire4 = false
          #make the track 0 so it will start from the 1st track
          @track_playing = 0
          playTrack(@track_playing, @albums)
        elsif area_clicked2(mouse_x, mouse_y)
          @entire2 = true
          @entire1 = false
          @entire3 = false
          @entire4 = false
          @track_playing = 0
          playTrack(@track_playing, @albums)
        elsif area_clicked3(mouse_x, mouse_y)
          @entire3 = true
          @entire1 = false
          @entire2 = false
          @entire4 = false
          @track_playing = 0
          playTrack(@track_playing, @albums)
        elsif area_clicked4(mouse_x, mouse_y)
          @entire4 = true
          @entire1 = false
          @entire2 = false
          @entire3 = false
          @track_playing = 0
          playTrack(@track_playing, @albums)
        elsif area_clicked5(mouse_x, mouse_y)
          @entire4 = false
          @entire1 = false
          @entire2 = false
          @entire3 = false
          @track_playing = 0
          playTrack(@track_playing, @albums)
        elsif area_clicked_button(mouse_x, mouse_y)
          @track_playing = 0
          playTrack(@track_playing, @albums)
        end
          #receive from the intialize @entire = false
	  end
	end
end
# Show is a method that loops through update and draw
MusicPlayerMain.new.show if __FILE__ == $0
