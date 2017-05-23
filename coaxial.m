% alpha is the angle between the plane and left intersectioin point with
% cylinder.
alpha = pi/4;

% c is the distance between zero and intersection point
c = 1;
A = c;
B = -c;

% Size is maximal abs of point that will be ploted
size = 4;
% Step for mesh grid. Decrease for denser(more percise) solution
step = 0.04;

[x, y] = meshgrid(-size:step:size, -size:step:size);
z = complex(x, y);

% converting to coaxial coordinates
ksi = angle(z-A)-angle(z-B);
eta = log(abs(z-A)./abs(z-B));
% gamma is a complex coaxial coordinate(needed to compute complex potential)
gamma = ksi + 1i.*eta;

%vector of fluid speed on an infinite distance
v = complex(1, 0);

n = alpha * 2 / pi;
% computing potential
% see Tomson M. "Theoretical hydrodynamics" (1964)
w = (v * 2 * c * 1i / n) * cot(gamma./n);

% now that we have computed potential, we have to discard potential under
% the surface.
center = complex(0, tan(pi/2 - alpha));
R = abs(center - A);

for i = 1:(size * 2/step + 1)
    for j = 1:(size * 2/step + 1)
       if abs(z(i,j) - center) <= R
           w(i,j) = complex(0, 0);
       end
       if imag(z(i,j)) <= 0
           w(i,j) = complex(0, 0);
       end
    end
end
%finished discarding

figure;
% for flow curves we only need imaginary part of that potential
contour(x,y,imag(w),30);

% now let's draw the surface itself
hold on;
z = [];
for x = -size:0.01:size
    if abs(x) > c
        z = [complex(x, 0); z];
    end
end
for i = 0:0.01:360
    angl = i / 360*2*pi;
    pos = complex(cos(angl), sin(angl)) * R + center;
    if imag(pos) >= 0
        z = [pos; z];
    end
end

plot(real(z),imag(z),'r.','MarkerSize',5);

%make sure that axis are equal to provide better readability
axis('equal');