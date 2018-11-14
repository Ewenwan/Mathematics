function [a] = sortrow(a)
% a=ceil(rand(10,4)*3);
a=sortrows(a,1);
tmp=unique(a(:,1));
tmp_count=histc(a(:,1),tmp);
start_box=0;
end_box=0;
i=1;
startloc=1;
endloc=0;
while(i<length(tmp_count)+1)
    endloc=endloc+tmp_count(i);
    if tmp_count(i)>1
      a(startloc:endloc,:) = sortrows(a(startloc:endloc,:),2);  
      start_box=[start_box startloc];
      end_box=[end_box endloc];
    end
    startloc=startloc+tmp_count(i);
    i=i+1;
end
for i=2:length(start_box)
    tmp=unique(a(start_box(i):end_box(i),2));
    tmp_count=histc(a(start_box(i):end_box(i),2),tmp);
    ii=1;
    startloc=start_box(i);
    endloc=start_box(i)-1;
    while(ii<length(tmp_count)+1)
    endloc=endloc+tmp_count(ii);
    if tmp_count(ii)>1
      a(startloc:endloc,:) = sortrows(a(startloc:endloc,:),3);  
    end
    startloc=startloc+tmp_count(ii);
    ii=ii+1;
    end
end