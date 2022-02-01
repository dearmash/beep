$fn=60;

led_board_radius=9.65/2;
led_board_height = 1;

board_radius=79/2;
board_height=3;

intersection() {
  difference() {
    // The basic square for the 'board'
    linear_extrude(board_height) square(board_radius*2, center=true);
    
    // Subtract out the led holes
    {
      sectors = 24;
      sector_degrees = 360 / sectors;
      for(sector = [1 : sectors]) {
        angle = sector_degrees * (sector+0.5);
        // Polar equ for 'squircle', awesome: https://thatsmaths.com/2016/07/14/squircles/
        radius = (1 + 1/8 * sin(2*angle)*sin(2*angle)) * (board_radius-led_board_radius);
        
        rotate([0, 0, angle])
          translate([radius, 0, -1])
          led_board();
      }
    }

    // Subtract out the inner circle
    translate([0, 0, -1]) 
      linear_extrude(board_height+2)
      circle(board_radius-10);
  }
  
  // intersect to subtract the outer circle
  translate([0, 0, -1]) 
    linear_extrude(board_height+2)
    circle(board_radius+10);
}

/** Just draw the led board, centered, on the plane, 5 tall, expected 1 extra height each direction for difference */
module led_board() {
  linear_extrude(led_board_height+1) circle(led_board_radius);
  linear_extrude(board_height+2) square(5.2, center=true);
}
