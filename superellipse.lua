-- void drawEllipse(Graphics2D g)
    -- {
  
        -- final int a = 200; // a = b
        -- double[] points = new double[a + 1];
  
        -- Path2D p = new Path2D.Double();
        -- p.moveTo(a, 0);
  
        -- // calculate first quadrant
        -- for (int x = a; x >= 0; x--) {
            -- points[x] = pow(pow(a, exp) - pow(x, exp), 1 / exp); // solve for y
            -- p.lineTo(x, -points[x]);
        -- }
  
        -- // mirror to others
        -- for (int x = 0; x <= a; x++)
            -- p.lineTo(x, points[x]);
  
        -- for (int x = a; x >= 0; x--)
            -- p.lineTo(-x, points[x]);
  
        -- for (int x = 0; x <= a; x++)
            -- p.lineTo(-x, -points[x]);
  
        -- g.translate(getWidth() / 2, getHeight() / 2);
        -- g.setStroke(new BasicStroke(2));
  
        -- g.setColor(new Color(0x25B0C4DE, true));
        -- g.fill(p);
  
        -- g.setColor(new Color(0xB0C4DE)); // LightSteelBlue
        -- g.draw(p);
    -- }
    
-- // Return coordinates using PARAMETRIC EQUATION
-- // Default arguments yield unit circle; first three arguments only give a "normal" ellipse
-- Point getPoint( double theta, double a = 1.0, double b = 1.0, double m = 2.0, double n = 2.0 )
-- {
   -- Point p;
   -- double c = cos( theta );               
   -- double s = sin( theta );               
   -- p.x = a * pow( abs( c ), 2.0 / m );   if ( c < 0 ) p.x = -p.x;
   -- p.y = b * pow( abs( s ), 2.0 / n );   if ( s < 0 ) p.y = -p.y;
   -- return p;
-- }


local function superellipse_cartesian(a,b,n)
    --(a, 0)
    points = {}
    for x = a, 0, -1 do
        points[x] = math.pow(math.pow(a,n) - math.pow(x,n), 1 / n)
    end
    for x,y in ipairs(points) do
        print(200-x,y)
    end
end

--superellipse_cartesian(200,200,2.5)

local function superellipse_polar_point(theta, radius, a, b, m, n)
    --(a, 0)
    local c = math.cos(theta)
    local d = math.sin(theta)
    local x = a * math.pow( math.abs( c ), 2 / m ) * radius
    if c < 0 then
        x = -x
    end
    local y = b * math.pow( math.abs( d ), 2 / n ) * radius
    if d < 0 then
        y = -y
    end
    return x,y
end

print(superellipse_polar_point(0, 1.5, 1, 1, 2, 2))
print(superellipse_polar_point(math.pi/2, 1.5, 1, 1, 2, 2))
for n=1,2,0.01 do
    print(n,superellipse_polar_point(math.pi/4, 1.5, 1, 1, n, n))
end
print(1.7070707,superellipse_polar_point(math.pi/4, 1.5, 1, 1, 1.70707070707, 1.70707070707))
