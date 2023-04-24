function save_eigs(eigvals, eigvecs, filename)
    CSV.write(filename, DataFrame(eigvecs))
end