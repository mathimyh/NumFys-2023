function save_eigs(eigvals, eigvecs, x_size, filename)
    save(filename, "eigvals", eigvals, "eigvecs", eigvecs, "x_size", x_size)
end
    