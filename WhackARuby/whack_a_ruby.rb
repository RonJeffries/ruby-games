require 'gosu'

class WhackARuby < Gosu::Window

  def initialize
    super 800,600,false
    self.caption = "Whack the Ruby!"
    @image = Gosu::Image.new(self,'ruby.png', false)
    @hammer_image = Gosu::Image.new(self, 'hammer.png', false)
    @x = 200
    @y = 200
    @width = 50
    @height = 43
    @velocity_x = 5
    @velocity_y = 5
    @visible = 0
    @hit = 0
    @font = Gosu::Font.new(self, "system", 30)
    @score = 0
    @playing = true
    @start_time = 0
  end

  def button_down(id)
    if @playing
      if ( id == Gosu::MsLeft )
        if Gosu.distance(mouse_x,mouse_y, @x, @y) < 50 and @visible >= 0
          @hit = 1
          @score += 5
        else
          @hit = -1
          @score -= 1
        end
      end
    else 
      if ( id == Gosu::KbSpace )
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end

  def draw
    @image.draw(@x - @width/2, @y-@height/1, 1) if @visible > 0
    @hammer_image.draw(mouse_x-40, mouse_y-10,1)
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    draw_quad(0,0,c,800,0,c,800,600, c, 0, 600, c)
    @font.draw(@score.to_s,700,20,2)
    @font.draw(@time_left.to_s, 20,20,2)
    if not @playing
      @font.draw("GAME OVER", 300,300,3)
      @font.draw("Press Space to Play Again", 175,350,3)
      @visible = 20
    end
  end

  def update
    if @playing
      @visible -= 1
      if @visible < -10 and rand < 0.01
        @visible = 30
      end
      @x += @velocity_x
      @y += @velocity_y
      if @x + @width/2 > 800 or @x - @width/2 < 0
        @velocity_x *= -1
      end
      if @y + @height/2 > 600 or @y - @height/2 < 0
        @velocity_y *= -1
      end
    @time_left = (10-((Gosu.milliseconds - @start_time)/1000)).to_s
    if Gosu.milliseconds - @start_time > 10000
      @playing = false
    end
    end
  end
end

window = WhackARuby.new
window.show