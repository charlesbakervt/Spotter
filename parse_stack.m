function ims=parse_stack(filename,first,last,tform)

% ims=parse_stack(filename)
% 12/11/09
% Parses metamorph stack file with S 2D images of size n*m and outputs a
% n*m*S double 3D array if tform is specified, the stack is spatially
% transformed.


info=imfinfo(filename);
if last>length(info),
    last=length(info);
end

if nargin < 2
    stack = imread(filename);
else
    if nargin <4
        stack=zeros(1024,1024,last-first+1);
        
        for i=first:last,
            stack(:,:,i) = imread(filename,i,'info',info);%returns double
            %stack(:,:,i) = imread(filename,'Index',i,'Info',info);%returns uint16
        end
    
    else
        stack=zeros(1024,1024,last-first+1);
        
        for i=first:last,
            tmp = imread(filename,i,'info',info);%returns double
            stack(:,:,i) = imtransform(tmp, tform, ...
            'XData', [1, size(stack, 2)], ...
            'YData', [1, size(stack, 1)]);
        end
    end
        
end

ims=stack;

% [n,m]=size(stack(1).data);
% ims=zeros(n,m,length(stack));
%
% for i=1:length(stack),
%     %ims(:,:,i)=double(stack(i).data);
%     ims(:,:,i)=stack(i).data;
% end
%
% if FILTER_OUTLIER,
%     ind=find((ims-mean(ims(:)))/std(ims(:))>ZTHRESH);
%     if ~isempty(ind),
%         index=min(find((ims-mean(ims(:)))/std(ims(:))>ZTHRESH));
%         ims(ind)=ims(index);
%     end
% end