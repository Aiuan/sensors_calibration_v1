function img_rgb = raw2rgb(path, r_gain, g_gain, b_gain)
    width = 2880;
    height = 1860;
    num_bit = 12;
    num_byte =((num_bit - 1) / 8 + 1);

    fid = fopen(path ,"r");
    data = fread(fid, width*height, 'uint16');
    fclose(fid);
    
    img = reshape(data, width, height);
    img = img';
    img_maxValue = max(max(img));
    img_minValue = min(min(img));
    
    % 读取3个通道的采样数据
    % bgbg.....|grgr....
    r = zeros(size(img,1));
    g = zeros(size(img));
    b = zeros(size(img));
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            if (mod(i,2) ~= 0)%奇数行bgbgbg...
                if (mod(j,2) ~= 0)%奇数列b
                    b(i,j) = img(i,j);
                else%偶数列g
                    g(i,j) = img(i,j);
                end
            else%偶数行grgr....
                if (mod(j,2) ~= 0)%奇数列g
                    g(i,j) = img(i,j);
                else%偶数列r
                    r(i,j) = img(i,j);
                end
            end
        end
    end
    
    % 插值
    R = interpR(r);
    G = interpG(g);
    B = interpB(b);
    
    % 调色
    img_rgb = zeros(size(img,1),size(img,2),3);
    img_rgb(:,:,3) = (R - img_minValue)./(img_maxValue - img_minValue).*r_gain;
    img_rgb(:,:,2) = (G - img_minValue)./(img_maxValue - img_minValue).*g_gain;
    img_rgb(:,:,1) = (B - img_minValue)./(img_maxValue - img_minValue).*b_gain;

end


function R = interpR(r)
    R = r;
    for i = 1:size(R,1)
        for j = 1:size(R,2)
            if R(i,j) == 0 && i ~= 1 && i~=size(R,1) && j ~= 1 && j~=size(R,2)
                if R(i,j-1)~=0 && R(i,j+1)~=0
                    R(i,j) = (R(i,j-1) + R(i,j+1))/2;
                elseif R(i-1,j)~=0 && R(i+1,j)~=0
                    R(i,j) = (R(i-1,j) + R(i+1,j))/2;
                else
                    R(i,j) = (R(i-1,j-1) + R(i-1,j+1) + R(i+1,j-1) + R(i+1,j+1))/4;
                end 
            end
        end
    end
    for i = 1:size(R,1)
        for j = 1:size(R,2)
            if i == 1 && j ~= 1 && j ~= size(R,2)
                R(i,j) = 2*R(i+1,j) - R(i+2,j);
            elseif i == size(R,1) && j ~= 1 && j ~= size(R,2)
                R(i,j) = 2*R(i-1,j) - R(i-2,j);
            elseif j == 1 && i ~= 1 && i ~= size(R,1)
                R(i,j) = 2*R(i,j+1) - R(i,j+2);
            elseif j == size(R,2) && i ~= 1 && i ~= size(R,1)
                R(i,j) = 2*R(i,j-1) - R(i,j-2);      
            end
        end
    end
    R(1,1) = 2*R(2,2) - R(3,3);
    R(1,size(R,2)) = 2*R(2,end-1) - R(3,end-2);
    R(size(R,1),1) = 2*R(end-1,2) - R(end-2,3);
    R(size(R,1),size(R,2)) = 2*R(end-1,end-1) - R(end-2,end-2);
end

function G = interpG(g)
    G = g;
    for i = 1:size(G,1)
        for j = 1:size(G,2)
            if G(i,j) == 0 && i ~= 1 && i~=size(G,1) && j ~= 1 && j~=size(G,2)
                if G(i,j-1)~=0 && G(i,j+1)~=0
                    G(i,j) = (G(i,j-1) + G(i,j+1))/2;
                elseif G(i-1,j)~=0 && G(i+1,j)~=0
                    G(i,j) = (G(i-1,j) + G(i+1,j))/2;
                else
                    G(i,j) = (G(i-1,j-1) + G(i-1,j+1) + G(i+1,j-1) + G(i+1,j+1))/4;
                end 
            end
        end
    end
    for i = 1:size(G,1)
        for j = 1:size(G,2)
            if i == 1 && j ~= 1 && j ~= size(G,2)
                G(i,j) = 2*G(i+1,j) - G(i+2,j);
            elseif i == size(G,1) && j ~= 1 && j ~= size(G,2)
                G(i,j) = 2*G(i-1,j) - G(i-2,j);
            elseif j == 1 && i ~= 1 && i ~= size(G,1)
                G(i,j) = 2*G(i,j+1) - G(i,j+2);
            elseif j == size(G,2) && i ~= 1 && i ~= size(G,1)
                G(i,j) = 2*G(i,j-1) - G(i,j-2);      
            end
        end
    end
    G(1,1) = 2*G(2,2) - G(3,3);
    G(1,size(G,2)) = 2*G(2,end-1) - G(3,end-2);
    G(size(G,1),1) = 2*G(end-1,2) - G(end-2,3);
    G(size(G,1),size(G,2)) = 2*G(end-1,end-1) - G(end-2,end-2);
end

function B = interpB(b)
    B = b;
    for i = 1:size(B,1)
        for j = 1:size(B,2)
            if B(i,j) == 0 && i ~= 1 && i~=size(B,1) && j ~= 1 && j~=size(B,2)
                if B(i,j-1)~=0 && B(i,j+1)~=0
                    B(i,j) = (B(i,j-1) + B(i,j+1))/2;
                elseif B(i-1,j)~=0 && B(i+1,j)~=0
                    B(i,j) = (B(i-1,j) + B(i+1,j))/2;
                else
                    B(i,j) = (B(i-1,j-1) + B(i-1,j+1) + B(i+1,j-1) + B(i+1,j+1))/4;
                end 
            end
        end
    end
    for i = 1:size(B,1)
        for j = 1:size(B,2)
            if i == 1 && j ~= 1 && j ~= size(B,2)
                B(i,j) = 2*B(i+1,j) - B(i+2,j);
            elseif i == size(B,1) && j ~= 1 && j ~= size(B,2)
                B(i,j) = 2*B(i-1,j) - B(i-2,j);
            elseif j == 1 && i ~= 1 && i ~= size(B,1)
                B(i,j) = 2*B(i,j+1) - B(i,j+2);
            elseif j == size(B,2) && i ~= 1 && i ~= size(B,1)
                B(i,j) = 2*B(i,j-1) - B(i,j-2);      
            end
        end
    end
    B(1,1) = 2*B(2,2) - B(3,3);
    B(1,size(B,2)) = 2*B(2,end-1) - B(3,end-2);
    B(size(B,1),1) = 2*B(end-1,2) - B(end-2,3);
    B(size(B,1),size(B,2)) = 2*B(end-1,end-1) - B(end-2,end-2);
end