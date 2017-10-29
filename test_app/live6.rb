n = 5
(1..n).each { |i|
    (1..n).each { |num|
        if n % 2 == 0
            if (num) % 2 == 0
                print "="
            else
                print "+"
            end            
        else
            if (i + num) % 2 == 0
                print "+"
            else
                print "="
            end
        end
    }
    print "\n"
}

# 3
# +=+
# =+=
# +=+

# 4
# +=+=
# +=+=
# +=+=
# +=+=

# 5
# +=+=+
# =+=+=
# +=+=+
# =+=+=
# +=+=+

#※宿題24との違いは、nが偶数のときに先頭が+になるか=になるか、です。