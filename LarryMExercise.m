clear, clc, close all

touchAreaX = zeros(10); %touch area
touchAreaY = zeros(10);

for x=1:10
    for y=1:10
        for n=1:10000
            
            touchAreaX(x,y,n)= x + normrnd(0,4);
        end
    end
end

for x=1:10
    for y=1:10
        for n=1:10000
            
            touchAreaY(x,y,n)= y + normrnd(0,4);            
        end
    end
end

figure, hold on
for x=1:10
    for y=1:10
        scatter(squeeze(touchAreaX(x,y,:)),squeeze(touchAreaY(x,y,:)))
        drawnow
    end
end
axis equal

%%
award = zeros(10,10,10000);

for x=1:10
    for y=1:10
        for n=1:10000
            if and(touchAreaY(x,y,n) >= 0, touchAreaY(x,y,n) < 10)
                if and(touchAreaX(x,y,n) >= 0, touchAreaX(x,y,n) < 5)
                    award(x,y,n) = -10;
                elseif and(touchAreaX(x,y,n) >= 5, touchAreaX(x,y,n) < 10)
                    award(x,y,n) = 10;
                end
            end
        end
    end
end

figure,
surf(mean(award,3));
colorbar
xlabel('x')
ylabel('y')
zlabel('mean award')


