-- sketch-domain.lua

-- canvas defines how big the drawing canvas is
L1=pnts.s1; L2=pnts.d; R1=pnts.m2; R2=pnts.c;
xmin=L1.x; ymin=L2.y; xmax=R1.x; ymax=R2.y

s = Sketch:new{renderer="svg", projection="xyortho",canvas_mm={0.0,0.0,100.0,100.0*(ymax-ymin)/(xmax-xmin)}}
s:set{viewport={xmin-0.1*R,ymin-0.1*R,xmax+0.1*R,ymax+0.1*R}}

s:start{file_name="Domain-draft.svg"} -- Give output file a name

-- Give the plot a title
s:text{point=Vector3:new{x=(xmin+xmax)/2,y=ymax-0.1*R},
    text="Domain",
    font_size=16
}

-- Plot the lines
s:set{line_width=0.5, line_colour="blue"}; s:render{path=Arc_s}
s:set{line_width=0.5, line_colour="blue"}; s:render{path=Bez_out}
s:set{line_width=0.5, line_colour="blue"}; s:render{path=Bez_in}
s:set{line_width=0.5, line_colour="blue"}; s:render{path=Line1}
s:set{line_width=0.5, line_colour="blue"}; s:render{path=Bez_a}
s:set{line_width=0.5, line_colour="blue"}; s:render{path=Bez_b}
s:set{line_width=0.5, line_colour="blue"}; s:render{path=Bez_c}
s:set{line_width=0.5, line_colour="blue"}; s:render{path=Bez_d}

-- Add node points to sketch 
s:dotlabel{point=pnts.centr, label="centr"}
s:dotlabel{point=pnts.a, label="a"}; s:dotlabel{point=pnts.b, label="b"} 
s:dotlabel{point=pnts.c, label="c"}; s:dotlabel{point=pnts.d, label="d"} 
s:dotlabel{point=pnts.s1, label="s1"}; s:dotlabel{point=pnts.s2, label="s2"}
s:dotlabel{point=pnts.m1, label="m1"}; s:dotlabel{point=pnts.m2, label="m2"} 
s:dotlabel{point=pnts.r1, label="r1"}; s:dotlabel{point=pnts.r2, label="r2"} 
s:dotlabel{point=pnts.r3, label="r3"}; s:dotlabel{point=pnts.r4, label="r4"}
s:dotlabel{point=pnts.e1, label="e1"}; s:dotlabel{point=pnts.e2, label="e2"}   
s:dotlabel{point=pnts.e3, label="e3"}; s:dotlabel{point=pnts.e4, label="e4"}
s:dotlabel{point=pnts.p1, label="p1"}; s:dotlabel{point=pnts.p2, label="p2"} 
s:dotlabel{point=pnts.p3, label="p3"}; s:dotlabel{point=pnts.p4, label="p4"}  

s:finish{}