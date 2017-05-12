

function get_symplectic_conjugate_coefficients{T}(a::Matrix{T}, b::Vector{T}, a̅::Matrix{T})
    @assert size(a) == size(a̅)
    @assert length(b) == size(a,1) == size(a,2)

    for i in 1:size(a̅, 1)
        for j in 1:size(a̅, 2)
            a̅[i,j] = b[j] * ( one(T) - a[j,i] / b[i] )
        end
    end
    nothing
end


function get_symplectic_conjugate_coefficients{T}(coeff::CoefficientsRK{T})
    a̅ = zeros(coeff.a)
    get_symplectic_conjugate_coefficients(coeff.a, coeff.b, a̅)
    CoefficientsRK(coeff.name, coeff.s, a̅, coeff.b, coeff.c)
end


function check_symplecticity{T}(coeff::CoefficientsRK{T})
    symplectic = falses(coeff.s, coeff.s)

    for i in 1:size(coeff.a, 1)
        for j in 1:size(coeff.a, 2)
            symplectic[i,j] = isapprox(coeff.b[i] * coeff.a[i,j] + coeff.b[j] * coeff.a[j,i], coeff.b[i] * coeff.b[j], atol=16*eps(T), rtol=16*eps(T))
        end
    end

    symplectic
end


function check_symmetry{T}(coeff::CoefficientsRK{T})
    symmetric = falses(coeff.s, coeff.s)

    for i in 1:size(coeff.a, 1)
        for j in 1:size(coeff.a, 2)
            symmetric[i,j] = isapprox(coeff.a[coeff.s+1-i, coeff.s+1-j] + coeff.a[i,j], coeff.b[j], atol=16*eps(T), rtol=16*eps(T))
        end
    end

    symmetric
end


function check_order_conditions_B{T}(coeff::CoefficientsRK{T}, k)
    local res::T = 0

    for i in 1:coeff.s
        res += coeff.b[i] * coeff.c[i]^(k-1)
    end

    return isapprox(res, 1/k, atol=16*eps(T), rtol=16*eps(T))
end


function check_order_conditions_C{T}(coeff::CoefficientsRK{T}, k)
    local order  = falses(coeff.s)
    local res::T

    for i in 1:size(coeff.a, 1)
        res = 0
        for j in 1:size(coeff.a, 2)
            res += coeff.a[i,j] * coeff.c[j]^(k-1)
        end
        order[i] = isapprox(res, coeff.c[i]^k/k, atol=16*eps(T), rtol=16*eps(T))
        # println(res - coeff.c[i]^k/k)
    end

    order
end


function check_order_conditions_D{T}(coeff::CoefficientsRK{T}, k)
    local order  = falses(coeff.s)
    local res::T

    for i in 1:size(coeff.a, 1)
        res = 0
        for j in 1:size(coeff.a, 2)
            res += coeff.b[j] * coeff.c[j]^(k-1) * coeff.a[j,i]
        end
        order[i] = isapprox(res, coeff.b[i] * (1 - coeff.c[i]^k)/k, atol=16*eps(T), rtol=16*eps(T))
        # println(res - coeff.b[i] * (1 - coeff.c[i]^k)/k)
    end

    order
end