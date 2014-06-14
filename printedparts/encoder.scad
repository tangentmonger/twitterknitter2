/* for knitting machinve v2
next time, make it taller (2mm thickness) */

NUM_SECTIONS = 48; 	/* number of interrupters*2 */
INT_MODIFIER = -0.3;  /* interrupter-width modifier
								range:[-1..1] 
								=0 => 	interrupter = hole 
								<0 =>	interrupter > hole
								>0 => interrupter < hole
							*/

R_OUTER = 26;			/* outer radius of the encoder */
BORDER = 1;				/* a filled border  */
R_INNER2 = 22;			/* inner radius -> inner radius 2, phase shifted interrupters for direction detection */
R_INNER = 19;			/* inner radius -> filled */


R_MOUNT = 17;			/* mounting hole outline radius */
R_HOLE = 5;				/* mounting hole radius */
R_CROSS = 1.9;			/* center-cross for 2d encoders*/


THICKNESS = 3;	   		/* thickness of the encoder */
THICKNESS_MOUNT = 2;  /* thickness of the mouting hole outline */


$fs = 0.01;

/* generates encoder contour */
module encoder_contour(n,rin,rout,mod){
	 for (i = [1:2:n])
    {
        assign (a1 = i*360/n, a2 = (i+1+mod)*360/n )
        {	
                polygon(points=[
						[cos(a2)*rin,sin(a2)*rin],
						[cos(a1)*rin,sin(a1)*rin],
						[cos(a1)*rout,sin(a1)*rout],
						[cos(a2)*rout,sin(a2)*rout] 
					]);
			}
    }	
}

/* use this to create a hole outline */
module hole2d(rhole,rcross){
	 circle(r = rhole);
	 polygon(points=[[0,0.1],[rcross,0],[0,-0.1],[-rcross,0] ] );
	 polygon(points=[[0.1,0],[0,rcross],[-0.1,0],[0,-rcross] ] );
}

module encoder3d(n,rin,rin2,rout,rhole,rmount,border,mod,t,tm) {
	echo();
	difference(){
		union(){
			cylinder(h=t,r=rout);
			cylinder(h=tm,r=rmount);			
		}
		translate([0,0,t-tm]){cylinder(h=tm,r=rmount);}
		linear_extrude(height=5*t,center=true) encoder_contour(n,rin,rin2,mod);
		rotate([0,0,360/(4*n)]) linear_extrude(height=5*t,center=true) encoder_contour(n,rin2-$fs,rout-border,mod);
		cylinder(h=5*t,r=rhole,center=true);
	}
}

module encoder2d(rin,rout,rhole,rcross,mod) {
	hole2d(rhole,rcross);
	encoder_contour(rin,rout,mod);
}


encoder3d(NUM_SECTIONS,R_INNER,R_INNER2,R_OUTER,R_HOLE,R_MOUNT,BORDER,INT_MODIFIER,THICKNESS,THICKNESS_MOUNT);
//encoder2d(NUM_SECTIONS,R_INNER,R_OUTER,R_HOLE,R_CROSS,INT_MODIFIER);
