using Gadfly

type DynamicSystem
	f::Function
	x0
	DynamicSystem(f,x0) = new(f,x0)
end

#test test
function RK4step( f::Function, x, h )

   k1 = f(x);
   k2 = f(x+0.5*h*k1);
   k3 = f(x+0.5*h*k2);
   k4 = f(x+h*k3);

   return (h/6.0)*((k1+2.0*k2+2.0*k3)+k4);
end

#bla blubb
function RK4( f::Function, x0, T, N::Integer = 100)

   x = x0;
   h = T/N;
   for i=1:N
        x += RK4step( f, x, h );
   end
   return x;
end



function DynamicSystemPlot(Dyn::DynamicSystem,Npoint=100,Npath=20,resol=0.01,width=0.05,Op="s")
x0 = Dyn.x0
function g(t)
	return RK4(Dyn.f,x0,t)
end
	st = "plot("
	stend = ")"
	lay = Array(AbstractString,Npath)
	xaxis = Array(Float64,0)
	yaxis = Array(Float64,0)

	for i = 1:Npath
		xaxis = Array(Float64,1)
		yaxis = Array(Float64,1)
		x0 = [width*i+Dyn.x0[1];Dyn.x0[2]]
		xaxis[1] = x0[1]
		yaxis[1] = x0[2]
		for j = 1:Npoint
			Temp = g(resol*j)
			xaxis=[xaxis;Temp[1]]
			yaxis=[yaxis;Temp[2]]
		end
		eval(Expr(:(=),parse("xaxis$i"),xaxis))
		eval(Expr(:(=),parse("yaxis$i"),yaxis))
		lay[i] = "layer(x=xaxis$i,y=yaxis$i,Geom.path)"
		if i==Npath
			st = string(st,lay[i],)
		else
			st = string(st,lay[i],",")
		end
	end
	st = string(st,stend)
	if Op == "PNG"
		p = eval(parse(st))
		draw(PNG("DynamicSystem.png",12cm,12cm),p)
	else
		eval(parse(st))
	end
end
