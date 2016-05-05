using Gadfly

type DynamicSystem
	f::Function
	x0
	DynamicSystem(f,x0) = new(f,x0)
end

#test test
function rk4step( f::Function, x, h )

   k1 = f(x);
   k2 = f(x+0.5*h*k1);
   k3 = f(x+0.5*h*k2);
   k4 = f(x+h*k3);

   return (h/6.0)*((k1+2.0*k2+2.0*k3)+k4);
end

#bla blubb
function rk4( f::Function, x0, t_end, npoint::Integer = 100)

   x = x0;
   h = t_end/npoint;
   for i=1:npoint
        x += rk4step( f, x, h );
   end
   return x;
end



function dynamicSystemPlot(dyn::DynamicSystem;npoint::Integer=100,npath::Integer=20,
resol=0.01,width=0.05,start_time=0,rk4_npoint=100,option="s")

x0 = dyn.x0
function g(t)
	return rk4(dyn.f,x0,t,rk4_npoint)
end
	st = "plot("
	stend = ")"
	lay = Array(AbstractString,npath)

	for i = 1:npath
		xaxis = Array(Float64,1)
		yaxis = Array(Float64,1)
		x0 = [width*i+dyn.x0[1];dyn.x0[2]]
		offset = g(start_time)
		xaxis[1] = offset[1]
		yaxis[1] = offset[2]
		for j = 1:npoint
			Temp = g(resol*j+start_time)
			xaxis=[xaxis;Temp[1]]
			yaxis=[yaxis;Temp[2]]
		end
		eval(Expr(:(=),parse("xaxis$i"),xaxis))
		eval(Expr(:(=),parse("yaxis$i"),yaxis))
		lay[i] = "layer(x=xaxis$i,y=yaxis$i,Geom.path)"
		if i==npath
			st = string(st,lay[i],)
		else
			st = string(st,lay[i],",")
		end
	end

	st = string(st,stend)
	if option == "PNG"
		p = eval(parse(st))
		draw(PNG("DynamicSystem.png",12cm,12cm),p)
	else
		eval(parse(st))
	end
end
