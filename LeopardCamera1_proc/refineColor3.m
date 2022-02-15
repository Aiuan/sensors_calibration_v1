function image_refineColor = refineColor3(img_rgb)
   
     IM = img_rgb;
     old_img_lin = rgb2lin(IM);
     Percentile = 10;
     illuminant = illumwhite(old_img_lin, Percentile); % 假设前 Percentile% 最亮的红色、绿色和蓝色值代表白色来 估计 RGB 图像中的场景照明
     new_img_lin = chromadapt(old_img_lin,illuminant,'ColorSpace','linear-rgb');
     new_img = lin2rgb(new_img_lin);
     final_img = new_img;
     
  

    % 动态阈值算法  用来做二次白平衡,适用于傍晚不太亮的场景； 晚上的话就不太需要二次白平衡
%      im = new_img;
%      im1 = rgb2ycbcr(im);
%     
%      Lu=im1(:,:,1);
%      Cb=im1(:,:,2);
%      Cr=im1(:,:,3);
%      [x, y, z]=size(im);
%      tst=zeros(x,y);
%     
%      % 计算Cb、Cr的均值Mb、Mr
%      Mb=mean(mean(Cb));
%      Mr=mean(mean(Cr));
%     
%      % 计算Cb、Cr的均方差
%      Db=sum(sum(Cb-Mb))/(x*y);
%      Dr=sum(sum(Cr-Mr))/(x*y);
%     
%      % 根据阀值的要求提取出near-white区域的像素点
%      cnt=1;
%      for i=1:x
%          for j=1:y
%              b1=Cb(i,j)-(Mb+Db*sign(Mb));
%              b2=Cr(i,j)-(1.5*Mr+Dr*sign(Mr));
%              if (b1<abs(1.5*Db) & b2<abs(1.5*Dr))
%                 Ciny(cnt)=Lu(i,j);
%                 tst(i,j)=Lu(i,j);
%                 cnt=cnt+1;
%              end
%          end
%      end
%      cnt=cnt-1;
%      iy=sort(Ciny,'descend');%将提取出的像素点从亮度值大的点到小的点依次排列%
%      Reference = 7;
%      brightness = 9;
%      nn=round(cnt/Reference);
%      Ciny2(1:nn)=iy(1:nn);%提取出near-white区域中10%的亮度值较大的像素点做参考白点%
%     
%      % 提取出参考白点的RGB三信道的值
%      mn=min(Ciny2);
%      for i=1:x
%          for j=1:y
%              if tst(i,j)<mn
%                 tst(i,j)=0;
%              else
%                 tst(i,j)=1;
%              end
%          end
%      end
%     
%      R=im(:,:,1);
%      G=im(:,:,2);
%      B=im(:,:,3);
%      R=double(R).*tst;
%      G=double(G).*tst;
%      B=double(B).*tst; 
%     
%      % 计算参考白点的RGB的均值
%      Rav=mean(mean(R));
%      Gav=mean(mean(G));
%      Bav=mean(mean(B));
%      Ymax=double(max(max(Lu)))/brightness;%计算出图片的亮度的最大值%
%     
%      % 计算出RGB三信道的增益
%      Rgain=Ymax/Rav;
%      Ggain=Ymax/Gav;
%      Bgain=Ymax/Bav;
%     
%      % 通过增益调整图片的RGB三信道
%      im(:,:,1)=im(:,:,1)*Rgain;
%      im(:,:,2)=im(:,:,2)*Ggain;
%      im(:,:,3)=im(:,:,3)*Bgain;
%      final_img = im;
    
    rr=0.75;   gr=0.35;   br=-0.1;
    rg=0.05;   gg=0.85;    bg=0.1;
    rb=-0.1;    gb=0.3;   bb=0.8;
    rgbena = [rr, gr, br; rg, gg, bg; rb, gb, bb];

    myimg = final_img;
    for i = 1:size(myimg,1)
        for j = 1:size(myimg,2)
            oldrgb = [myimg(i,j,1); myimg(i,j,2); myimg(i,j,3)];
            newrgb = rgbena * oldrgb;
            myimg(i,j,1) = newrgb(1);
            myimg(i,j,2) = newrgb(2);
            myimg(i,j,3) = newrgb(3);
        end
    end
    final_img = myimg;
    
    image_refineColor = final_img;


end