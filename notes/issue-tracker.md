# Issue Tracker

** Protocol extension computed bir değer verir, yani her okumada hesaplanan sabit bir şeydir. status alanı değişebileceği için sonradan bunu değiştirmek bu şekilde mümkün olmaz.

** Durum tutan (stored) şeyler protokolde { get set } ile şart koşulur, her tip kendi saklama alanını açar. Türetilen (computed) şeyler protocol extension'dan varsayılan olarak gelir: summary gibi.
