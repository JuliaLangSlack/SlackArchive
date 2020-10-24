# Preview of Slack Helpdesk History 
 
 ### User: U8MPCDJAY Timestamp:_2020-10-24T20:47:25.05_: 
```
I’m trying to make some highly async code interrupt-friendly with try-catches, and most of the time it works, but every so often I hit this. Is there any way to figure out what it was doing in julia code at the time?
^Cfatal: error thrown and no exception handler available.
InterruptException()
jl_mutex_unlock at /Users/ian/Documents/GitHub/julia/src/./locks.h:139 [inlined]
jl_task_get_next at /Users/ian/Documents/GitHub/julia/src/partr.c:475
poptask at ./task.jl:744
wait at ./task.jl:752 [inlined]
task_done_hook at ./task.jl:478
_jl_invoke at /Users/ian/Documents/GitHub/julia/src/gf.c:0 [inlined]
jl_apply_generic at /Users/ian/Documents/GitHub/julia/src/gf.c:2373
jl_apply at /Users/ian/Documents/GitHub/julia/src/./julia.h:1690 [inlined]
jl_finish_task at /Users/ian/Documents/GitHub/julia/src/task.c:208
start_task at /Users/ian/Documents/GitHub/julia/src/task.c:832
```

### User: U8D9768Q6 Timestamp:_2020-10-24T20:45:30.049_: 
```
(though it's a rather big `if` about whether that's actually something we want to support)
```


```
There's a lot of things where people design `AbstractArray`  functions to support arbitrary offsets, but for the most part assume unit spacing. If we wanted better irregularly spaced array support, we'd likely need functions like `first(::AbstractArray, ::Int)`
```

```
I don't see how that'd be a concern. Shouldn't it just return the same type as `getindex` on a slice would?
```
### User: U01ARRMLM7E Timestamp: 2020-10-24T20:39:58.043: 
```
What's the situation where the output type of `first(x,3)` differs from the input type?
```
[View Thread]()

### User: U012XER8K4M Timestamp:_2020-10-24T20:38:52.042_: 
```
Perhaps a combination of `[1:3]` already exists, and some questions about what the output type should be, considering the myriad of array types.
```

### User: U8D9768Q6 Timestamp:_2020-10-24T20:38:45.042_: 
```
With `Array`s, you can just do `arr[begin:begin+3]`, but it would be nice to have a `first` method like for strings.
```


```
No, not really. The reason it exists for `AbstractString` is that indexing them is a bad idea when unicode is involved:
julia&gt; first("∀ϵ≠0: ϵ²&gt;0", 3)
"∀ϵ≠"

julia&gt; "∀ϵ≠0: ϵ²&gt;0"[1:3]
ERROR: StringIndexError("∀ϵ≠0: ϵ²&gt;0", 3)
Stacktrace:
 [1] string_index_err(::String, ::Int64) at ./strings/string.jl:12
 [2] getindex(::String, ::UnitRange{Int64}) at ./strings/string.jl:250
 [3] top-level scope at REPL[3]:1
```
### User: U01ARRMLM7E Timestamp:_2020-10-24T20:34:40.04_: 
```
Is there some fundamental reason why this method doesn't/shouldn't exist?
&gt; first([1,2,3], 3)
ERROR: MethodError: no method matching first(::Array{Int64,1}, ::Int64)
```

### User: U018S3HQGRK Timestamp:_2020-10-24T20:10:28.038_: 
```
i have a small widget with sliders in pluto.jl, i've been trying to add a "reset" button to make them go back to default values. anyone can help with this?
```

### User: U017LQ3A59U Timestamp: 2020-10-24T19:55:10.036: 
```
Is there a known way to "reparametrize" a struct in a generic way? That is given an object of type `A{T}` I would like to be able to return a new object of type `A{S}` (taking care of the conversion from `T` to `S` manually). If I have a single type it's easy enough, I can define
reparametrize(a::A{T}) where T = A{S}( #convert internal params to S here# )
But if I want `A` not to be more generic i.e. `A &lt;: SuperType` I can't get my head around how do it to get a function with the following signature
reparametrize(a::A) where {T, A &lt;: SupertType{T}) 
```
[View Thread]()

### User: U0176MBG29X Timestamp: 2020-10-24T19:41:47.027: 
```
Is there any way to limit the stacktrace from ~20 levels of depth to just the top 5 levels or something like that? The stacktrace often takes up my entire screen
```
[View Thread]()

### User: UGU761DU2 Timestamp: 2020-10-24T18:52:35.022: 
```
Note that `Gray` will be expecting numbers scaled from 0 (black) to 1 (white)
```
[View Thread]()

### User: UGU761DU2 Timestamp:_2020-10-24T18:51:06.022_: 
```
Or view right in your terminal with ImageInTerminal.jl
```


```
Which should show up as an image in Juno or VSCode, and which you could save to a file with e.g. `save("somefilename.png", img)`
```

```
Which will give you a “`100×100 Array{Gray{Float64},2} with eltype Gray{Float64}:`”
```

```
What are you starting with? If you’re starting say with a matrix of numbers you could do
using Images
a = rand(100,100)
img  = Gray.(a)
```
### User: U018S3HQGRK Timestamp:_2020-10-24T18:24:31.017_: 
```
sorry for the beginner questions.. how do i show a grayscale image?
```

### User: UGR3910CQ Timestamp: 2020-10-24T17:44:10.015: 
```
This is a test
```
[View Thread]()

### User: U01C2E6TYEM Timestamp: 2020-10-24T16:05:21.009: 
```
Is there any reason why inv([x]) has a missing method (i.e. 1x1 arrays do not have an inverse)? Is it at all ambiguous to just write?
inv(x::Array{Int64,1}) = [1/x[1]]

```
[View Thread]()

### User: U01C8179LB0 Timestamp: 2020-10-24T14:53:26.004: 
```
A beginner’s issue with metaprogramming: Say we want to define a macro that substitutes input expression into code and the resulting expression is afterwards evaluated in the caller’s scope. like this
macro foo(ex)
    :(Array{Int64}(undef, $ex))
end

let
    a = [1, 2]
    @foo length(a)
end
I’d like to substitute the `ex` with `length(a)` and evaluate it within the local scope. However, it doesn’t work: The $ does the expansion and finds out that `a` is missing in the macro scope, while `ex` can’t be used either. Any hint?
```
[View Thread]()

### User: U018S3HQGRK Timestamp: 2020-10-24T13:37:12.494: 
```
hey, trying out julia, given an RGB image? how to i get an array that only has the red channel?
```
[View Thread]()

### User: U01C2E6TYEM Timestamp: 2020-10-24T13:07:30.494: 
```
How should I deal with n x m matrices where I want to extract the size, but one of n or m is possibly 1, hence Julia returns a single value rather than a tuple?
size([2, 1]) = (2,)
I need to fill in an upper triangular matrix with zeros of sizes that depend on the size of its surrounding blocks.
```
[View Thread]()

### User: U010LT79LKX Timestamp: 2020-10-24T12:39:36.49: 
```
Is there a fast speech to text library in Julia?
```
[View Thread]()

### User: ULX78CTC3 Timestamp: 2020-10-24T11:52:17.488: 
```
I am writing tests for a package where a method needs some user input(using readLine()). Is there any way I can get julia to automatically send the input when the readLine() method is supposed to take an input?
```
[View Thread]()

### User: ULX78CTC3 Timestamp: 2020-10-24T10:47:37.484: 
```
What might be the fastest way to check if all tuple elements are 1? I
```
[View Thread]()

### User: U011V84GZ5E Timestamp: 2020-10-24T09:01:13.482: 
```
Hello community, is it possible to retrieve the type and size of input &amp; output arguments of a function? E.g. input: Float64 vector of length N and output Int array of size KxL? This would be usefull for troubleshooting I guess:
`typeof(J_AD)`
`var"#17#18"`
Or am I missing something? Thanks
```
[View Thread]()

### User: U01B0JZ4SJF Timestamp:_2020-10-24T06:19:20.471_: 
```
how can i send status code in genie
```

### User: UKG4WF8PJ Timestamp:_2020-10-24T03:41:33.47_: 
```
what is recommended, return an error or throw an error?
```

### User: UM3GCDFGR Timestamp: 2020-10-24T03:20:27.468: 
```
I have one super simple question, say we have a dataframe `df` with two columns `share` and `year`, how to create a new column `res_share` which is the residual share in each year? In R that would be: `df %&gt;% group_by(year) %&gt;% 1-sum(share)`. But somehow I can't figure out how to do this in Query (or in plain Julia without writing ugly loops)
```
[View Thread]()

### User: U01ACUZR8CC Timestamp: 2020-10-24T02:22:57.462: 
```
Hey folks. I’m trying to use Optim.jl for a small problem but keep running into precompile issues and the errors don’t seem to have any useful information (to my best knowledge). Any ideas what could be causing the issue (error posted in thread)?
```
[View Thread]()

### User: U677R5Q5A Timestamp:_2020-10-24T01:12:55.46_: 
```
Thank you for bearing with me, good old XY problem I suppose – as well as not continuing in an ancient thread elsewhere. Background here: <https://julialang.slack.com/archives/CBF3Z1D7V/p1602646185191500> What I am trying to achieve is patching Pkg to include a few lines to apply necessary patches for binaries to run on NixOS – the lines themselves are ~5 and not scary. However, as Pkg is in base that would mean touching the system image. Ideally, I would like to make this work without rebuilding Julia from source (this is the “easy” way) so that one can rely on the official binaries to the largest extent possible on a wonky OS like NixOS.
```

### User: UKG4WF8PJ Timestamp: 2020-10-23T21:30:19.457: 
```
is there a way to check if the io on where im printing results has support for unicode?
```
[View Thread]()

### User: UEN48T0BT Timestamp: 2020-10-23T20:55:14.453: 
```
Is there a way to dispatch on keys of NamedTuples? Like:
struct Foo end
struct Bar end
tnt = (Foo() =&gt; anything1, Bar() =&gt; anything2) # not allowed, but similar to NamedTuple
@test getproperty(tnt, Foo()) == anything1
@test getproperty(tnt, Bar()) == anything2
Or are there types like this defined somewhere?
```
[View Thread]()

### User: U8D9768Q6 Timestamp:_2020-10-23T20:12:18.449_: 
```
There's `std` from the `Statistics` standard library.
julia&gt; using Statistics: std

julia&gt; std(randn(1000))
0.9768968828910654
```

### User: U019ZKQ5YQ6 Timestamp:_2020-10-23T20:07:02.448_: 
```
Eyo! what is UP. Just like "mean." can find the mean of multiple lists at once, is there then one function that can find the standard deviation or some kind of spread measure?
```

### User: U7Y2Y04RJ Timestamp: 2020-10-23T19:26:06.443: 
```
Hi all. I wanna know If there is a way to create a macro to represent an access _v[i]_ of an array _v_ as something like xi (math style).
```
[View Thread]()

### User: U019K6Q9N15 Timestamp: 2020-10-23T19:07:30.438: 
```
Is there any way to dispatch a function for a type alias? Or do I have to make a struct which minimally wraps the alias and reimplement the methods which I wanted to get from the alias? Consider the specific example of creating an alias for `Dict{Symbol, Int}` . This type has a bunch of nice methods, but one might also imagine that I'd like to distinguish between my inhabitants of it and inhabitants of my alias with, for example, `Base.show` .
```
[View Thread]()

### User: U01ARRMLM7E Timestamp: 2020-10-23T19:06:35.437: 
```
What's the equivalent of
In [3]: list(itertools.product([1,2,3],repeat=2))
Out[3]: [(1, 1), (1, 2), (1, 3), (2, 1), (2, 2), (2, 3), (3, 1), (3, 2), (3, 3)]
in Julia?
```
[View Thread]()

### User: UJ7DVTVQ8 Timestamp:_2020-10-23T17:30:23.431_: 
```
Anyone knows what was breaking in the latest realease of `FillArrays`?
```

### User: U012RPHRSP3 Timestamp: 2020-10-23T17:11:59.43: 
```
while trying to update `Franklin.jl` I ran into the error  `ERROR: ArgumentError: Unsupported architecture 'aarch64' for macOS`. I tried running `pkg&gt; update`and `pkg&gt; resolve` as suggested here: <https://discourse.julialang.org/t/unsupported-architecture/48786>, but that did not help. I am using julia 1.5.0 and windows 10. Any suggestions what I should do?
```
[View Thread]()

### User: UE6BDNM9B Timestamp: 2020-10-23T16:52:51.427: 
```
how to get the dependencies of a package, such as Flux@0.10.4
```
[View Thread]()

### User: U019ZKQ5YQ6 Timestamp: 2020-10-23T16:37:52.423: 
```
If i have a dataset with 1.000.000 obs. is there a way to select the first 1000 then skip 9000 and then select 10.000-11.000 etc?
```
[View Thread]()

### User: U0176MBG29X Timestamp: 2020-10-23T16:23:45.422: 
```
How can I log both to console as well as a file (and flush after each log line)? Basically I am trying to combine the following into the same global logger:
logger = ConsoleLogger(io, <http://Logging.Info|Logging.Info>)
global_logger(logger)

logger = ConsoleLogger(stdout, <http://Logging.Info|Logging.Info>)
global_logger(logger)

```
[View Thread]()

### User: U6Z8377N2 Timestamp: 2020-10-23T16:08:46.42: 
```
I was wondering what is the most Julia way to return data. I have a function that can return two different results. This is what I have so far
function bar()
   res1 = zeros(Float64, 1000)
   res2 = zeros(Float64, 1000)
   # algorithm to fill in res1 and res2
   return res1, res2
end
but maybe I am thinking of using a `kwarg`
function bar(;result_type)
   res1 = zeros(Float64, 1000)
   res2 = zeros(Float64, 1000)
   # algorithm to fill in res1 and res2
   if result_type == :first
     return res1
   else 
     return res2
   end
end
I like the second option because there is code downstream which assumes `bar()` returns a single array (but that's really not that big of a deal). Third option would be to use a struct?
struct MyResults
   res1::Array{Float64, 1} 
   res2::Array{Float64, 1}
end
function bar()
   res1 = zeros(Float64, 1000)
   res2 = zeros(Float64, 1000)
   # algorithm to fill in res1 and res2
   res = MyResults() 
   res.res1 = res1 
   res.res2 = res2
   return res
end
but I think this is unneccesarily making things complicated
```
[View Thread]()

### User: U6Z8377N2 Timestamp: 2020-10-23T15:27:59.417: 
```
I guess, I could just map over integers and index in. Or use `enumerate`
```
[View Thread]()

### User: U6Z8377N2 Timestamp:_2020-10-23T15:27:43.416_: 
```
Is it possible to get the index of an array when using `map` I have code like this
res = map(myarray) do x 
   do stuff with x
   do special things if x is the first element 
end
but I don't really know how to do the second item there
```

### User: U6C937ENB Timestamp: 2020-10-23T15:26:02.415: 
```
Wat?
julia&gt; f(;args::T...)where {T} = T
ERROR: syntax: space before "{" not allowed in "where {" at none:1

```
[View Thread]()

### User: U01CUQ4B67J Timestamp: 2020-10-23T14:25:09.412: 
```
maybe close it first
```
[View Thread]()

### User: U7HAYKY9X Timestamp: 2020-10-23T14:23:11.412: 
```
I have a bewildering situation. I have generated some `Expr` , let's call it `code` . Now if I do
function foo()
    $code
end
it works. But if I do
# Print code to file
open(io -&gt; println(io, code), "foo.jl", "w")
# read in code
code2 = Meta.parse(String(open(read, "foo.jl")))
function foo()
    $code2
end
then it errors. Should these two behave the same? Edit: Figured it out, see thread.
```
[View Thread]()

### User: UC6B1TT7B Timestamp: 2020-10-23T13:28:28.408: 
```
It happens quite often (from time to time) that I have a set of elements, and want to create a dictionary mapping each unique element in the set to the number of occurrences of it in the set, like this:
count_dict = Dict(map(element -&gt; element =&gt; count(element .== my_set), unique(my_set)))
Does there exists a function for this
(like I can manage without, but it seemed like something which might exist, and if it does, I should ask)
```
[View Thread]()

### User: U019ZKQ5YQ6 Timestamp: 2020-10-23T13:26:09.405: 
```
If i have a dataframe and i only want to look at each 10th observation, how do i do that?
```
[View Thread]()

### User: U677R5Q5A Timestamp:_2020-10-23T13:12:42.403_: 
```
Thank you <@USU9FRPEU>, I ended up reading a slightly more general one (<https://julialang.github.io/PackageCompiler.jl/dev/devdocs/sysimages_part_1/>), but now I feel much more comfortable with the process.

Follow-up question: If I want to change definitions in the base system image (rather than add another module), I suppose I would change the code in Base, find a way to unload the module, and then apply the same logic described in the link above?

Sorry if this is “too advanced” for the help desk.
```

### User: U012UUNBFM0 Timestamp: 2020-10-23T13:01:58.403: 
```
Can I plot a matrix like this in Julia?
```
[View Thread]()

### User: U017YGFQTE3 Timestamp: 2020-10-23T12:19:45.401: 
```
I'm looking for an iterator that generates the same output as
Base.Iterators.product([0:1 for i in 1:n]...) 
but where the output is ordered in the total number of 1s. So, the first element should be all zeros, then the next block are all the `(0,...,0,1,0,...0)`, before the elements with two 1s, and so on.
Another option that would work for me would be something akin to `Itertools.subsets` but where the output is ordered in the size of the subsets.
```
[View Thread]()

### User: U01D75CD203 Timestamp: 2020-10-23T12:17:06.4: 
```
Hello, in matlab language, we can use figure(1) and figure(2) to creat two independent plots. How should I do in Julia language? It shows that in Julia,
x = plot( 1:10, rand(10, 1 ) )  # x-plot
y = plot( 1:10, rand(10, 1 ) )  # y-plot
the screen will show only the second plot, and one has to use display function to show x-plot or y-plot, but not both. Google tells that an option of plot,
"reuse = false", of y-plot will solve this problem in REPL, but it shows that this does not work in script or function environment. I do not want to do subplot either.

 Is there any trick to solve this problem?
```
[View Thread]()

### User: U73KENNG4 Timestamp:_2020-10-23T11:19:59.393_: 
```
Is there some easy way to make the `MethodError: no method matching keymap(::Vector{Dict})` on master go away?
```

### User: UN45LV5K6 Timestamp:_2020-10-23T10:25:03.391_: 
```
How do I make sure that channels are closed properly when a producer or consumer fails, without the following to deadlock:
producer(c1, c2) = foreach(x -&gt; (put!(c1, x); put!(c2, x)), 1:3)
consumer1(c) = foreach(x -&gt; println("One: ", x), c)
consumer2(c) = foreach(x -&gt; println("Two: ", x), c)

@sync begin
    c1 = Channel()
    c2 = Channel()
    
    t = @async producer(c1, c2)
    bind(c1, t)
    bind(c2, t)

    @async consumer1(c1)
    @async consumer2(c2)
end
The `bind` only works for errors in `producer`, but not `consumer`.
```

### User: U7GQE9JP9 Timestamp: 2020-10-23T10:18:35.388: 
```
Hello,

I hope this is not a very dump question. I would like to associate a manifest.toml to a .jl file. Is it possible or do I need to create a package?
```
[View Thread]()

### User: U014LRLJXRP Timestamp: 2020-10-23T07:53:14.386: 
```
I am trying to implement `rref` in a modulo field, but I am having trouble with all-zero rows.  I wonder if someone could take a look at my code (in thread) and see where I am going wrong, because I’m at a loss…
```
[View Thread]()

### User: U014LRLJXRP Timestamp: 2020-10-23T05:11:28.379: 
```
How might I go about writing a function that takes in a matrix `G` and a number `m` (which is the modulus of the field), and outputs all unique linear combinations?

I have a feeling I need to use `@nloops`, so I have written this:
@generated function get_codewords(G::AbstractArray, ::Val{n}, m::Integer) where n
    quote
        Base.Cartesian.@nloops $n i d -&gt; 0:m-1 begin
            wᵢ = vec([(Base.Cartesian.@ntuple $n i)...]) .* Base.Cartesian.@nextract 1 x d -&gt; G[d, :]
            println(wᵢ)
        end
    end
end
get_codewords(G::AbstractArray, m::Integer) = get_codewords(G, Val(size(G, 1)), m)
But this is not quite what I want.  Any ideas?  I am a little new to the Linear Algebra game in Julia, so I am probably _way_ overcomplicating it…
```
[View Thread]()

### User: U677R5Q5A Timestamp:_2020-10-23T03:39:25.372_: 
```
Apologies, this is stuff I should know by experience. But apparently I am getting old.
```

### User: U677R5Q5A Timestamp: 2020-10-23T03:39:07.372: 
```
I somehow seem to have failed to wrap my head around the docs. But is there any way to rebuild/build a system image without needing a complete checkout of the Julia source tree?
```
[View Thread]()

### User: UM3GCDFGR Timestamp: 2020-10-23T03:17:25.371: 
```
100: dist = 940031.0555043541
200: dist = 841554.7489537231
julia&gt; 300: dist = 824895.3910763789^C


julia&gt;
^C

julia&gt;
600: dist = 803526.8252443164
700: dist = 760113.3374338557
800: dist = 741908.676501098
900: dist = 735667.8233516186
I got something like above
```
[View Thread]()

### User: UM3GCDFGR Timestamp:_2020-10-23T03:17:02.37_: 
```
Would anyone tell me how to interrupt `Optim.optimize`? I tried `cntr+c` but it doesn't work.. It will just continue to optimize unless I kill the whole Julia session
```

### User: US64J0NPQ Timestamp: 2020-10-23T03:03:44.369: 
```
Would anyone with expertise in GTK be willing to help me with this issue here: <https://github.com/JuliaGraphics/Gtk.jl/issues/529>

In short, what I am trying to do is grab a previously created GTK window that is created by a Julia script and "recycle" it in such way as to not have to open and close a new GTK window every single time I run the script. I want to use the same GTK each time I run my script. How do I do this?
```
[View Thread]()

### User: U014LRLJXRP Timestamp: 2020-10-23T01:52:12.365: 
```
Why is `\endash` and `\emdash` listed in the <https://docs.julialang.org/en/v1.5/manual/unicode-input/|unicode support> but when I use it I get `syntax: invalid character "–" near column 1`?…
```
[View Thread]()

### User: U014LRLJXRP Timestamp: 2020-10-23T01:21:53.361: 
```
If I have an identity matrix followed by some other stuff (e.g., `[1 0 0 2 3 0; 0 1 0 1 2 2; 0 0 1 4 3 0]`), is there a way in Julia to return only the part of the matrix that isn’t the identity?  E.g., return `[2 3 0; 1 2 2; 4 3 0]`?
```
[View Thread]()

### User: U01724Q3PGW Timestamp: 2020-10-23T00:47:22.359: 
```
Is there a way to plot with a second y axis (say, on the right) on a single plot? I didn't see anything in the Plots.jl examples or tutorial and stackoverflow wasn't much use either... I tried `axis=:right`, but it must be an unknown symbol
```
[View Thread]()

### User: U01C5HUV05U Timestamp: 2020-10-22T21:55:24.349: 
```
How can I cube an entire array?
```
[View Thread]()

### User: U01BA7WDYB1 Timestamp: 2020-10-22T21:04:45.348: 
```
I encountered some strange behaviour while testing the speed of sampling 1 out of 3 values with specified sampling weights. One of the values is null so I mistakenly used `Nothing` to represent it (instead of `nothing`, whose type is actually Nothing). The code is something like this:
M = M_trans(params...)
@time for i in 1:1000000
    sample([1, 0, Nothing], aweights(M[s0, :]))
end
which returns `0.640328 seconds (5.00 M allocations: 289.917 MiB, 4.92% gc time)`. I decided to fix it by using `nothing` but unexpectedly this results in a &gt;10x decrease in speed: `8.461066 seconds (7.00 M allocations: 350.952 MiB, 0.42% gc time)`.
Ultimately I'll just use an integer to encode the null value which is faster than both but I'm just curious about this behaviour. Should I avoid using `nothing` at all costs?
```
[View Thread]()

### User: U01C2P6BKSR Timestamp: 2020-10-22T20:10:06.342: 
```
Has anyone run into an issue with `using Flux` inside of a package lately? As of a couple hours ago, I get a bunch of errors about methods being overwritten and `incremental compilation may be fatally broken for this module`

I made an issue about it, but I'm really not sure what's going on at all: <https://github.com/FluxML/Flux.jl/issues/1370>
```
[View Thread]()

### User: UKG4WF8PJ Timestamp:_2020-10-22T19:09:50.337_: 
```
Optim.jl,JuMP.jl
```

### User: U015EGHQZP0 Timestamp:_2020-10-22T19:08:31.336_: 
```
Is there a package that lets you optimize nonlinear user-defined functions?
```

### User: UP4U6AKNZ Timestamp: 2020-10-22T18:24:19.334: 
```
The Julia Artifacts string macro `artifact"blabla"` appears to be dispatched on REPL behavior (only then it will look for the `toml` file  in `pwd()`): <https://github.com/JuliaLang/Pkg.jl/blob/aaf4e6e8ab784f7435c1bdc56832bc03e014dedb/src/Artifacts.jl#L1046> It fails for me when using it in a `notebook` environment (Basically doesn't find `Artifacts.toml`). Are there simple work-around solutions?
```
[View Thread]()

### User: U01D211HB0V Timestamp: 2020-10-22T17:54:22.327: 
```
I have a 2d array I create like `a = [rand(4) for i in [0]]` (simplified for clarity) and I want to broadcast `cos()` over it. However `cos.(a)` yields `MethodError: no method matching cos(::Array{Float64,1})` . What am I missing?
```
[View Thread]()

### User: UAREE2NMD Timestamp:_2020-10-22T17:41:52.324_: 
```
The following works fine:
julia&gt; using Dates

julia&gt; Dates.DateTime("2020-10-22T16:52:14.409Z", dateformat"yyyy-mm-dd\THH:MM:<http://SS.sZ|SS.sZ>")
2020-10-22T16:52:14.409
Now if I add to it `using` or even `import` of `TimeZones`, then now the same code fails:
julia&gt; using Dates

julia&gt; import TimeZones

julia&gt; Dates.DateTime("2020-10-22T16:52:14.409Z", dateformat"yyyy-mm-dd\THH:MM:<http://SS.sZ|SS.sZ>")
ERROR: ArgumentError: Unable to parse date time. Expected directive DatePart(Z) at char 22
Stacktrace:
 [1] macro expansion at /Users/julia/buildbot/worker/package_macos64/build/usr/share/julia/stdlib/v1.5/Dates/src/parse.jl:104 [inlined]
 [2] tryparsenext_core(::String, ::Int64, ::Int64, ::DateFormat{Symbol("yyyy-mm-dd\\THH:MM:<http://SS.sZ|SS.sZ>"),Tuple{Dates.DatePart{'y'},Dates.Delim{Char,1},Dates.DatePart{'m'},Dates.Delim{Char,1},Dates.DatePart{'d'},Dates.Delim{Char,1},Dates.DatePart{'H'},Dates.Delim{Char,1},Dates.DatePart{'M'},Dates.Delim{Char,1},Dates.DatePart{'S'},Dates.Delim{Char,1},Dates.DatePart{'s'},Dates.DatePart{'Z'}}}, ::Bool) at /Users/julia/buildbot/worker/package_macos64/build/usr/share/julia/stdlib/v1.5/Dates/src/parse.jl:38
 [3] macro expansion at /Users/julia/buildbot/worker/package_macos64/build/usr/share/julia/stdlib/v1.5/Dates/src/parse.jl:150 [inlined]
 [4] tryparsenext_internal at /Users/julia/buildbot/worker/package_macos64/build/usr/share/julia/stdlib/v1.5/Dates/src/parse.jl:125 [inlined]
 [5] parse(::Type{DateTime}, ::String, ::DateFormat{Symbol("yyyy-mm-dd\\THH:MM:<http://SS.sZ|SS.sZ>"),Tuple{Dates.DatePart{'y'},Dates.Delim{Char,1},Dates.DatePart{'m'},Dates.Delim{Char,1},Dates.DatePart{'d'},Dates.Delim{Char,1},Dates.DatePart{'H'},Dates.Delim{Char,1},Dates.DatePart{'M'},Dates.Delim{Char,1},Dates.DatePart{'S'},Dates.Delim{Char,1},Dates.DatePart{'s'},Dates.DatePart{'Z'}}}) at /Users/julia/buildbot/worker/package_macos64/build/usr/share/julia/stdlib/v1.5/Dates/src/parse.jl:282
 [6] DateTime(::String, ::DateFormat{Symbol("yyyy-mm-dd\\THH:MM:<http://SS.sZ|SS.sZ>"),Tuple{Dates.DatePart{'y'},Dates.Delim{Char,1},Dates.DatePart{'m'},Dates.Delim{Char,1},Dates.DatePart{'d'},Dates.Delim{Char,1},Dates.DatePart{'H'},Dates.Delim{Char,1},Dates.DatePart{'M'},Dates.Delim{Char,1},Dates.DatePart{'S'},Dates.Delim{Char,1},Dates.DatePart{'s'},Dates.DatePart{'Z'}}}) at /Users/julia/buildbot/worker/package_macos64/build/usr/share/julia/stdlib/v1.5/Dates/src/io.jl:482
 [7] top-level scope at REPL[8]:1
Looks like it is a bug and I reported it <https://github.com/JuliaTime/TimeZones.jl/issues/303|here>. But in the meantime, how can I work around this? (given that I do need to use both `Dates` and `TimeZones`)
```

### User: U018PBPUQBD Timestamp: 2020-10-22T17:31:11.321: 
```
Hello, for this code
#lower power flow limit
        @constraint(wildfire_model, 
                -ref[:branch][l]["rate_a"] &lt;= 
                sum(SF[l_index,j]*p[j] for j in 1:length(ref[:bus])) 
                    + sum(PSDF[l_index,j]*alpha[j] for j in 1:length(ref[:branch])))

        #upper power flow limit
        @constraint(wildfire_model, 
                sum(SF[l_index,j]*p[j] for j in 1:length(ref[:bus])) 
                    + sum(PSDF[l_index,j]*alpha[j] for j in 1:length(ref[:branch])))
                &lt;= ref[:branch][l]["rate_a"])
I am getting this error `syntax: "&lt;=" is not a unary operator` . This is in JuMP. I am not sure what I did wrong
```
[View Thread]()

### User: US64J0NPQ Timestamp: 2020-10-22T17:00:42.31: 
```
I am struggling on a data structure dilemma. I have a time series data set spread out across five different file formats. File 1 contains the time series, File 2 and 3 contains about how the data collection instrument was set up for that particular time series, File 4 contains additional time series information, and File 5 contains further information on the data collection instrument. These files exist for nearly 30 separate data recording sessions and each file could contain differing information that would be important for analysis. In total, this comes to about 3 billion data entries spread across these files.

How best could I structure this data? I have looked at RecursiveArrayTools.jl and thought that waspromising, AxisArrays.jl may also work as it can get me away from dictionaries, and AxisIndices (which looks like it builds on top of AxisArrays and makes it even better). Does anyone have any suggestions on what I should do here? Thanks for the help everyone! :smile:
```
[View Thread]()

### User: ULKHN71K3 Timestamp: 2020-10-22T16:41:37.305: 
```
I am discovering the joys and headaches of Named Tuples. How can I make this work?

`function nameparts(v)`
    `t = split(v,':')`
    `length(t) &lt; 2 ? (nothing,t[1]) : (t[1],t[2])`
`end`

`struct QName{T&lt;:AbstractString}`
    `pfx::Union{T,Nothing}`
    `nm::T`
`end`
`QName(nm::AbstractString) = QName(nameparts(nm)...)`

`struct ID{T&lt;:AbstractString}`
    `id::T`
`end`

`attr = Dict("base"=&gt;"xs:string")`
`atts = @NamedTuple{base::QName, id::Union{Nothing,ID}}`
`s = string.(fieldnames(atts))`
`vals = get.(Ref(attr), s, nothing) #vals will be strings or nothing`

Now I want to instantiate the types to create a result tuple that looks like
`(QName{SubString{String}}("xs", "string"), nothing)`

…but instantiating the NamedTuple gives an error
`maybe = atts(vals)`

ERROR: MethodError: Cannot `convert` an object of type
  String to an object of type
  QName
Closest candidates are:
  convert(::Type{T}, ::T) where T at essentials.jl:171
  QName(::AbstractString) at /Users/doug/dev/XSDJ/src/ex.jl:10
  QName(::Union{Nothing, T}, ::T) where T&lt;:AbstractString at /Users/doug/dev/XSDJ/src/ex.jl:7

What am I missing? Do I need to implement new methods for `convert` ?
```
[View Thread]()

### User: U019ZKQ5YQ6 Timestamp: 2020-10-22T16:06:58.297: 
```
What is going on :sob: I am pressing enter
```
[View Thread]()

### User: U6C937ENB Timestamp: 2020-10-22T15:31:53.295: 
```
I have a `t=(;a=f, b=g)` named tuple of functions and I want to transform this in a named tuple of return values, such  `ev(t, x)`  gives `(;a=f(x), b=g(x))`  The tricky part is reading the key names from the argument type of `t` of the function `ev` and use this somehow to create a new named tuple...
```
[View Thread]()

### User: U018Y8S0PK9 Timestamp: 2020-10-22T14:49:57.292: 
```
Is there a simple way to batch together a dataset of 3D images? I know flux has a flux.batch but I’m not sure if that works for 3D images 
```
[View Thread]()

### User: U7HAYKY9X Timestamp:_2020-10-22T14:46:58.29_: 
```
Is there a neat way of figuring out if a bitstype has a specific bit layout? For example, right now I do
function iszero(x::NTuple{16, UInt8})
    r = Ref(x)
    ptr = Ptr{UIn128}(pointer_from_objref(r))
    return iszero(unsafe_load(ptr))
end
```

### User: U013KHU2XC1 Timestamp: 2020-10-22T12:57:57.285: 
```
Getting a stable error on Taro activation. Any ideas on how to get more detailed description?

`export JULIA_COPY_STACKS=yes &amp;&amp; julia --project=.`
`julia&gt; using Taro`
`julia&gt; Taro.init()`

`signal (11): Segmentation fault: 11`
`in expression starting at REPL[2]:1`
`unknown function (ip: 0x13452f62d)`
`Allocations: 4054721 (Pool: 4053324; Big: 1397); GC: 5`

julia&gt; versioninfo()
Julia Version 1.5.2
Commit 539f3ce943 (2020-09-23 23:17 UTC)
Platform Info:
  OS: macOS (x86_64-apple-darwin18.7.0)
  CPU: Intel(R) Core(TM) i7-5557U CPU @ 3.10GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-9.0.1 (ORCJIT, broadwell)
Environment:
  JULIA_COPY_STACKS = yes
```
[View Thread]()

### User: U0111S7RTML Timestamp: 2020-10-22T12:37:52.283: 
```
Out of curiosity, is there an autodiff package that can mollify if statements?
```
[View Thread]()

### User: U01AYQ4HQHF Timestamp: 2020-10-22T10:40:33.282: 
```
Any idea what is wrong?
struct StVenant_rakenne

	Parametrit::Dict
	Johdannaisparametrit::Dict
	Joki::SharedArray

end

...

Johdannaisparametrit = Johdannaiset(s.Parametrit)

...

function Johdannaiset(Parametrit::Dict)

	dX = Parametrit["Pituus"] / (Parametrit["Laskentapisteet"] - 1)

	So = (Parametrit["Pohja_alkukorko"] - Parametrit["Pohja_loppukorko"]) / Parametrit["Pituus"]

	x = Dict{String,Float64}("dX" =&gt; dX, "So" =&gt; So)

	return x

end
This gets "ERROR: LoadError: MethodError: no method matching -(::String, ::Int64)
Closest candidates are:
  -(::Missing, ::Number) at missing.jl:115
  -(::BigInt, ::Union{Int16, Int32, Int64, Int8}) at gmp.jl:532
  -(::BigFloat, ::Union{Int16, Int32, Int64, Int8}) at mpfr.jl:425
  ..."
```
[View Thread]()

### User: UHZUXBR2P Timestamp: 2020-10-22T10:32:26.281: 
```
Is there a way to catch a warning? I want to redefine some constants, but instead of triggering a whole list of warnings, I thought it might be better to catch them and print a single one.
```
[View Thread]()

### User: U8J1KET6K Timestamp: 2020-10-22T09:21:39.275: 
```
Hi, I was just glancing at <https://docs.julialang.org/en/v1/manual/integers-and-floating-point-numbers/>  and in the table I saw that the boolean has 8 bits. Why does it have 8 instead of 1 ...?
```
[View Thread]()

### User: U6G4M02N4 Timestamp:_2020-10-22T09:18:10.274_: 
```
I'm looking for something that leverages some flavor of search trees to achieve intersections in ~ O(log(N)) time
```


```
Anybody know of a package to (efficiently) find intersections of N-dimensional meshes with lines, planes, etc?
```
### User: U7JQGPGCQ Timestamp: 2020-10-22T08:20:32.272: 
```
What's the best way currently to get `Pkg` to run in a reasonable time on Windows and Julia 1.5.2? Updating the registry currently takes something like 5 minutes for me, part of which is probably my lovely corporate antivir which I can't disable
```
[View Thread]()

### User: UM4TSHKF1 Timestamp:_2020-10-22T03:12:24.269_: 
```
Can verify that I reran a previously successful job to get this error
```

### User: UM4TSHKF1 Timestamp: 2020-10-22T03:08:36.269: 
```
Is anyone familiar with this build error I'm getting that wasn't an issue maybe an hour ago? Testing with Julia 1.4 on Ubuntu-latest via GitHub Actions
Run julia-actions/julia-buildpkg@latest
    Cloning default registries into `~/.julia`
    Cloning registry from "<https://github.com/JuliaRegistries/General.git>"
25l    Fetching: [&gt;                                        ]  0.0 %
    Fetching: [=============&gt;                           ]  31.9 %
    Fetching: [==================================&gt;      ]  83.0 %
      Added registry `General` to `~/.julia/registries/General`
   Updating registry at `~/.julia/registries/General`
   Updating git-repo `<https://github.com/JuliaRegistries/General.git>`
  Installed PooledArrays ───────────────── v0.5.3
  Installed ProgressMeter ──────────────── v1.4.0
  Installed MultipleTesting ────────────── v0.4.1
  Installed FileIO ─────────────────────── v1.4.3
  Installed StaticArrays ───────────────── v0.12.4
  Installed StatsBase ──────────────────── v0.33.2
  Installed Distributions ──────────────── v0.23.12
  Installed DataAPI ────────────────────── v1.3.0
  Installed Requires ───────────────────── v1.1.0
  Installed Artifacts ──────────────────── v1.3.0
  Installed OpenSpecFun_jll ────────────── v0.5.3+4
  Installed JLD2 ───────────────────────── v0.2.4
  Installed CategoricalArrays ──────────── v0.8.3
  Installed TableTraits ────────────────── v1.0.0
  Installed DataFrames ─────────────────── v0.21.8
  Installed CodecZlib ──────────────────── v0.7.0
  Installed PDMats ─────────────────────── v0.10.1
  Installed Rmath_jll ──────────────────── v0.2.2+1
  Installed IteratorInterfaceExtensions ── v1.0.0
  Installed Rmath ──────────────────────── v0.6.1
  Installed SortingAlgorithms ──────────── v0.3.1
  Installed MacroTools ─────────────────── v0.5.6
  Installed DataStructures ─────────────── v0.18.7
  Installed QuadGK ─────────────────────── v2.4.1
  Installed OrderedCollections ─────────── v1.3.1
  Installed StructTypes ────────────────── v1.1.0
  Installed Reexport ───────────────────── v0.2.0
  Installed JLLWrappers ────────────────── v1.1.2
  Installed SentinelArrays ─────────────── v1.2.16
  Installed DataValueInterfaces ────────── v1.0.0
  Installed FillArrays ─────────────────── v0.9.7
  Installed Tables ─────────────────────── v1.1.0
  Installed TranscodingStreams ─────────── v0.9.5
  Installed StatsFuns ──────────────────── v0.9.5
  Installed CompilerSupportLibraries_jll ─ v0.3.5+0
  Installed Parsers ────────────────────── v1.0.11
  Installed InvertedIndices ────────────── v1.0.0
  Installed Missings ───────────────────── v0.4.4
  Installed JSON ───────────────────────── v0.21.1
  Installed Zlib_jll ───────────────────── v1.2.11+18
  Installed Compat ─────────────────────── v3.21.0
  Installed SpecialFunctions ───────────── v0.10.3
  Installed CSV ────────────────────────── v0.7.7
ERROR: ArgumentError: Unsupported architecture 'aarch64' for macOS
Stacktrace:
 [1] MacOS at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.4/Pkg/src/BinaryPlatforms.jl:216 [inlined]
 [2] unpack_platform(::Dict{String,Any}, ::String, ::String) at /buildworker/worker/package_linux64/build/usr/share/julia/stdlib/v1.4/Pkg/src/Artifacts.jl:429
 [3] (::Pkg.Artifacts.var"#21#22"{String,String})(::Dict{String,Any}) at ./none:0
 [4] iterate at ./generator.jl:47 [inlined]
```
[View Thread]()

### User: ULZQ4DCSU Timestamp: 2020-10-22T02:45:47.267: 
```
Could anyone point out why the following is happening?  If `t0 ≤ t < t1 == true`, `ExcitatoryConductance` gives `ge  =   Ne*gbar*(finf+(f0-finf)` and ignores `exp(-t/tau)`.  Does this have something to do with my usage of constants?
```
[View Thread]()

### User: U8D9768Q6 Timestamp: 2020-10-22T02:12:17.261: 
```
Sorry, I don't understand why your `deepsym` function doesn't solve the issue. It does exactly what you say you want.
```
[View Thread]()

### User: U014LRLJXRP Timestamp:_2020-10-22T02:04:08.26_: 
```
Sorry if I am cluttering up the channel, but I also can’t figure out how to get a function to act on the innermost element of an abstract array?  I want:
julia deepsymbol([[1 2 3], [4 5 6]])
2-element Array{Symbol,1}:
 [Symbol(\"1\") Symbol(\"2\") Symbol(\"3\")]
 [Symbol(\"4\") Symbol(\"5\") Symbol(\"6\")]
Broadcastring `Symbol` makes the outer-most elements in the array `Symbol`s, and I have tried defining
julia&gt; deepsym(a::Number) = a
deepsym (generic function with 1 method)

julia&gt; deepsym(a) = Symbol.(deepsym.(a))
deepsym (generic function with 2 methods)
But that makes _everything_ symbols.  Any ideas? :slightly_smiling_face:
```

### User: U014LRLJXRP Timestamp: 2020-10-22T01:38:42.252: 
```
How can I use `where T` with a return type in a one-line function?
julia&gt; function myfunc(x::T)::T where T
    return x^2
    end
myfunc (generic function with 1 method)

julia&gt; myfunc(x::T)::T where T = x^2
ERROR: UndefVarError: T not defined

julia&gt; myfunc(x::T) where T = x^2
myfunc (generic function with 1 method)
```
[View Thread]()

### User: U018PBPUQBD Timestamp: 2020-10-22T01:13:40.246: 
```
Can I make values of a matrix into a Dict()?
```
[View Thread]()

### User: UHDQQ4GN6 Timestamp: 2020-10-22T00:37:20.244: 
```
I have a package with Python dependencies that uses `Base.prompt` to ask users if it should try auto-installing the dependnecy using either conda or pip. We need the Python package when precompiling to build docstrings. But it looks like `Base.prompt` never prompts the user during precompilation, so it fails. Any suggestions?
```
[View Thread]()

