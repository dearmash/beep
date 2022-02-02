$fn=60;

led_board_radius=5.05;
led_board_height=1;

board_radius=78/2;
board_height=1;

through_hole_radius=2.65;
screw_hole_radius=1.5;

intersection() {
  difference() {
    // The basic square for the 'board'
    linear_extrude(board_height) square(board_radius*2, center=true);
    
    // Subtract out the led holes
    translate([0, 2, 0])
      cube(57, center=true);
    *union() {
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
  
    // top left through hole
    translate([
        -(board_radius-(3.75+through_hole_radius)), 
        (board_radius-(4.75+through_hole_radius)),
        -1]) 
      linear_extrude(board_height+2)
      circle(through_hole_radius);
    // top right through hole
    translate([
        (board_radius-(3.75+through_hole_radius)), 
        (board_radius-(4.75+through_hole_radius)),
        -1]) 
      linear_extrude(board_height+2)
      circle(through_hole_radius);
    // bottom left through hole
    translate([
        -(board_radius-(5.75+through_hole_radius)), 
        -(board_radius-(3+through_hole_radius)),
        -1]) 
      linear_extrude(board_height+2)
      circle(through_hole_radius);
    // bottom right through hole
    translate([
        (board_radius-(5.75+through_hole_radius)), 
        -(board_radius-(3+through_hole_radius)),
        -1])
      linear_extrude(board_height+2)
      circle(through_hole_radius);
    // bottom middle through hole
    translate([
        0, 
        -(board_radius-(5.75+through_hole_radius)),
        -1]) 
      linear_extrude(board_height+2)
      circle(through_hole_radius);

    // top left screw hole
    translate([
        -(board_radius-(2.5+screw_hole_radius)), 
        (board_radius-(17+screw_hole_radius)),
        -1]) 
      linear_extrude(board_height+2)
      circle(screw_hole_radius);
    // top right screw hole
    translate([
        (board_radius-(2.5+screw_hole_radius)), 
        (board_radius-(17+screw_hole_radius)),
        -1]) 
      linear_extrude(board_height+2)
      circle(screw_hole_radius);
  }
  
  // intersect to subtract the 'ring'
  translate([0, 0, -1]) 
    linear_extrude(board_height+2)
    union() {
      // bottom middle through hole support
      translate([0, -(board_radius-(5.75+through_hole_radius)), 0])
      circle(through_hole_radius+3);
      difference() {
        circle(board_radius+13);
        circle(board_radius-12);
      }
    }

}

/** Draw the led board centered on the plane with extra height */
module led_board() {
  linear_extrude(led_board_height+1)
    circle(led_board_radius);
  linear_extrude(board_height+2)
    square(5.5, center=true);
  translate([-led_board_radius, -3.25/2, 0])
    cube([2*led_board_radius, 3.25, board_height+2]);
}
