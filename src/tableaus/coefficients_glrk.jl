
using FastGaussQuadrature
using Polynomials


function getCoefficientsGLRK1(T=Float64)
    a = reshape(Array{T}([1//2]), (1,1))
    b = Vector{T}([1//1])
    c = Vector{T}([1//2])
    o = 2

    CoefficientsRK(:glrk1, o, a, b, c)
end

function getCoefficientsGLRK2(T=Float64)
    a = Array{T}(@dec128 [
          [1/4       1/4-√3/6]
          [1/4+√3/6  1/4      ]
        ])
    b = Vector{T}(@dec128 [1/2,      1/2     ])
    c = Vector{T}(@dec128 [1/2-√3/6, 1/2+√3/6])
    o = 4

    CoefficientsRK(:glrk2, o, a, b, c)
end

function getCoefficientsGLRK3(T=Float64)
    a = Array{T}(@dec128 [
          [5/36         2/9-√15/15  5/36-√15/30]
          [5/36+√15/24  2/9         5/36-√15/24]
          [5/36+√15/30  2/9+√15/15  5/36       ]
        ])
    b = Vector{T}(@dec128 [5/18,        4/9,        5/18       ])
    c = Vector{T}(@dec128 [1/2-√15/10,  1/2,        1/2+√15/10 ])
    o = 6

    CoefficientsRK(:glrk3, o, a, b, c)
end

function getCoefficientsGLRK4(T=Float64)
    a = reshape(Array{T}(@dec128 [
         [(-√30/144 + 1/8)
          (-13*√42/336 - √10/16 - √3/12 + √(-60*√30 + 450)/144 + √35/28 + √(-2*√30 + 15)/8)/√(-2*√30 + 15)
          (-√35/28 - √10/16 - √3/12 + √(-60*√30 + 450)/144 + 13*√42/336 + √(-2*√30 + 15)/8)/√(-2*√30 + 15)
          (-√35/14 - √(60*√30 + 450)/144 - √42/168 + √(2*√30 + 15)/8)/√(2*√30 + 15)];
         [(-√(60*√30 + 450)/144 - √3/12 + √10/16 + √35/28 + 13*√42/336 + √(2*√30 + 15)/8)/√(2*√30 + 15)
          (√30/144 + 1/8)
          (-√35/14 + √42/168 + √(-60*√30 + 450)/144 + √(-2*√30 + 15)/8)/√(-2*√30 + 15)
          (-13*√42/336 - √35/28 - √(60*√30 + 450)/144 - √3/12 + √10/16 + √(2*√30 + 15)/8)/√(2*√30 + 15)];
         [(-√10/16 - √(60*√30 + 450)/144 + √3/12 + √35/28 + 13*√42/336 + √(2*√30 + 15)/8)/√(2*√30 + 15)
          (-√42/168 + √(-60*√30 + 450)/144 + √(-2*√30 + 15)/8 + √35/14)/√(-2*√30 + 15)
          (√30/144 + 1/8)
          (-13*√42/336 - √35/28 - √10/16 - √(60*√30 + 450)/144 + √3/12 + √(2*√30 + 15)/8)/√(2*√30 + 15)];
         [(-√(60*√30 + 450)/144 + √42/168 + √35/14 + √(2*√30 + 15)/8)/√(2*√30 + 15)
          (-13*√42/336 + √(-60*√30 + 450)/144 + √3/12 + √10/16 + √35/28 + √(-2*√30 + 15)/8)/√(-2*√30 + 15)
          (-√35/28 + √(-60*√30 + 450)/144 + √3/12 + √10/16 + 13*√42/336 + √(-2*√30 + 15)/8)/√(-2*√30 + 15)
          (-√30/144 + 1/8)]
        ]), (4,4))'

    b = Vector{T}(@dec128 [
          49/(216+12*√30),
          49/(216-12*√30),
          49/(216-12*√30),
          49/(216+12*√30)
        ])

    c = Vector{T}(@dec128 [
          1/2-√(3/7+2*√30/35)/2,
          1/2-√(3/7-2*√30/35)/2,
          1/2+√(3/7-2*√30/35)/2,
          1/2+√(3/7+2*√30/35)/2
        ])

    o = 8

    CoefficientsRK(:glrk4, o, a, b, c)
end

function getCoefficientsGLRK5(T=Float64)
    a = reshape(Array{T}(@dec128 [
         [-13*√70/3600 + 161/1800
          -59*√(20*√70 + 350)/19440 - 113*√(14*√70 + 245)/34020 - 11*√(-20*√70 + 350)/6480 + 4*√(-14*√70 + 245)/2835 + 13*√70/3600 + 161/1800
          -92*√(14*√70 + 245)/8505 + 4*√(20*√70 + 350)/1215 + 32/225
          -59*√(20*√70 + 350)/19440 - 113*√(14*√70 + 245)/34020 - 4*√(-14*√70 + 245)/2835 + 11*√(-20*√70 + 350)/6480 + 13*√70/3600 + 161/1800
          -2*√(14*√70 + 245)/315 - 13*√70/3600 + √(20*√70 + 350)/360 + 161/1800];
         [-113*√(-14*√70 + 245)/34020 - 13*√70/3600 + 4*√(14*√70 + 245)/2835 + 11*√(20*√70 + 350)/6480 + 59*√(-20*√70 + 350)/19440 + 161/1800
          13*√70/3600 + 161/1800
          -92*√(-14*√70 + 245)/8505 - 4*√(-20*√70 + 350)/1215 + 32/225
          -2*√(-14*√70 + 245)/315 - √(-20*√70 + 350)/360 + 13*√70/3600 + 161/1800
          -11*√(20*√70 + 350)/6480 - 113*√(-14*√70 + 245)/34020 - 13*√70/3600 - 4*√(14*√70 + 245)/2835 + 59*√(-20*√70 + 350)/19440 + 161/1800];
         [-23*√(20*√70 + 350)/5760 - 13*√70/3600 + 161/1800 + 11*√(14*√70 + 245)/1440
          13*√70/3600 + 23*√(-20*√70 + 350)/5760 + 11*√(-14*√70 + 245)/1440 + 161/1800
          32/225
          -11*√(-14*√70 + 245)/1440 - 23*√(-20*√70 + 350)/5760 + 13*√70/3600 + 161/1800
          -11*√(14*√70 + 245)/1440 - 13*√70/3600 + 161/1800 + 23*√(20*√70 + 350)/5760];
         [-59*√(-20*√70 + 350)/19440 - 13*√70/3600 + 4*√(14*√70 + 245)/2835 + 113*√(-14*√70 + 245)/34020 + 11*√(20*√70 + 350)/6480 + 161/1800
          13*√70/3600 + √(-20*√70 + 350)/360 + 2*√(-14*√70 + 245)/315 + 161/1800
          4*√(-20*√70 + 350)/1215 + 92*√(-14*√70 + 245)/8505 + 32/225
          13*√70/3600 + 161/1800
          -59*√(-20*√70 + 350)/19440 - 11*√(20*√70 + 350)/6480 - 13*√70/3600 - 4*√(14*√70 + 245)/2835 + 113*√(-14*√70 + 245)/34020 + 161/1800];
         [-√(20*√70 + 350)/360 - 13*√70/3600 + 161/1800 + 2*√(14*√70 + 245)/315
          -11*√(-20*√70 + 350)/6480 + 4*√(-14*√70 + 245)/2835 + 13*√70/3600 + 113*√(14*√70 + 245)/34020 + 59*√(20*√70 + 350)/19440 + 161/1800
          -4*√(20*√70 + 350)/1215 + 32/225 + 92*√(14*√70 + 245)/8505
          -4*√(-14*√70 + 245)/2835 + 11*√(-20*√70 + 350)/6480 + 13*√70/3600 + 113*√(14*√70 + 245)/34020 + 59*√(20*√70 + 350)/19440 + 161/1800
          -13*√70/3600 + 161/1800]
        ]), (5,5))'

    b = Vector{T}(@dec128 [
          1/(4600/729+1300*√70/5103),
          1/(4600/729-1300*√70/5103),
          64/225,
          1/(4600/729-1300*√70/5103),
          1/(4600/729+1300*√70/5103)
        ])

    c = Vector{T}(@dec128 [
          1/2-√(5/9+2*√70/63)/2,
          1/2-√(5/9-2*√70/63)/2,
          1/2,
          1/2+√(5/9-2*√70/63)/2,
          1/2+√(5/9+2*√70/63)/2
        ])

    o = 10

    CoefficientsRK(:glrk5, o, a, b, c)
end

function getCoefficientsGLRK6()
    a = reshape(Array{T}(@dec128 [
         [+0.04283112309479259005678402563042359859,
          -0.01476372599719741559792000534579747298,
          +0.009325050706477752841192179305402482994,
          -0.005668858049483512191376074370553011524,
          +0.002854433315099334704241265278037284292,
          -0.0008127801712647620388805211017064706800],
         [+0.09267349143037889422785775675203295485,
          +0.09019039326203463176648987349373603079,
          -0.02030010229323958276194776948751055391,
          +0.01036315624024642546641954630345121805,
          -0.004887192928037680001903523243585297203,
          +0.001355561055485059876513693910415981760],
         [+0.08224792261284399416360273958681733807,
          +0.1960321623332451126976450368359870862,
          +0.1169784836431725227563448142196238822,
          -0.02048252774565605503018072651122836435,
          +0.007989991899662258124947579271976810991,
          -0.002075625784866366900399437542673982054],
         [+0.08773787197445172925973548369537820950,
          +0.1723907946244078880540861381166084661,
          +0.2544394950319998764406332257249716829,
          +0.1169784836431730641931244226352311483,
          -0.01565137580917603632853275830168576886,
          +0.003414323576741135383507101481572811065],
         [+0.08430668513410013062409371268802929801,
          +0.1852679794521098125695487440229945290,
          +0.2235938110460935049196015841097066664,
          +0.2542570695795861919463812424893655494,
          +0.09019039326203400567639029563662244371,
          -0.007011245240794097943300544597026192570],
         [+0.08647502636084939178368041277081754636,
          +0.1775263532089750245675546653795481560,
          +0.2396258253358188537627739159334053272,
          +0.2246319165798698717500081657214692649,
          +0.1951445125212660677556409941923386316,
          +0.04283112309479195873707859915301793652]
        ]), (6,6))'

    b = Vector{T}(@dec128 [
           0.08566224618958517252014807108636644682,
           0.180380786524069303784916756918858056,
           0.2339569672863455236949351719947754974,
           0.2339569672863455236949351719947754974,
           0.180380786524069303784916756918858056,
           0.08566224618958517252014807108636644682
        ])

    c = Vector{T}(@dec128 [
           0.03376524289842398609384922275300269545,
           0.169395306766867743169300202490047326,
           0.3806904069584015456847491391596440323,
           0.6193095930415984543152508608403559677,
           0.830604693233132256830699797509952674,
           0.9662347571015760139061507772469973045
        ])

    o = 12

    CoefficientsRK(:glrk6, o, a, b, c)
end


function getCoefficientsGLRK(s::Int; T=Float64, high_precision=true)

    if high_precision == true
        if s == 1
            return getCoefficientsGLRK1(T)
        elseif s == 2
            return getCoefficientsGLRK2(T)
        elseif s == 3
            return getCoefficientsGLRK3(T)
        elseif s == 4
            return getCoefficientsGLRK4(T)
        elseif s == 5
            return getCoefficientsGLRK5(T)
        elseif s == 6
            return getCoefficientsGLRK6(T)
        end
    end


    # order
    o = 2s

    # obtain Gauss-Legendre nodes and weights
    q = GaussLegendreQuadrature(s, T)

    # create Lagrange polynomial
    vdm = vandermonde_matrix_inverse(nodes(q))

    # compute monomial basis functions and corresponding integrals
    poly_ints = []
    for i in 1:s
        y = zeros(s)
        y[i] = 1
        mon = *(vdm, y)
        push!(poly_ints, polyint(Poly(mon)))
    end

    # compute Runge-Kutta coefficients
    a = zeros(s,s)
    for i in 1:s
        for j in 1:s
            a[i,j] = poly_ints[j](nodes(q)[i])
        end
    end

    CoefficientsRK(Symbol("glrk", s), o, a, weights(q), nodes(q))
end
