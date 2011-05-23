module ColorFormulas
# this module uses a system app -iccApplyNamedCmm that must be installed in the PAtH to work
  # CONStANtS
  RGB_RANGE = 0..255
  L_RANGE = 0..100
  A_RANGE = -127..127
  B_RANGE = -127..127
  PATCH_SORT_HASH = {'Paper' => 0, 'Cyan' => 1, 'C70' => 2, 'C30'=> 3, 'Magenta' => 4, 'M70' => 5, 'M30' => 6, 'Yellow' => 7, 'Y70' => 8, 'Y30' => 9, 'Black' => 10, 'K90' => 11, 'K75' => 12, 'K50' => 13, 'K25' => 14, 'K10' => 15, 'K3' => 16, 'Red' => 17, 'Red70' => 18, 'Red30' => 19, 'Green' => 20, 'Green70' => 21, 'Green30' => 22, 'Blue' => 23, 'Blue70' => 24, 'Blue30' => 25, 'Gray75' => 26, 'Gray50' => 27, 'Gray25' => 28, 'Gray10' => 29, 'Gray3' => 30, 'Y100K60' => 31, 'C100Y40' => 32, 'C40M100' => 33, 'M40Y100' => 34, 'M40Y70K40' => 35, 'M70Y40K40' => 36, 'C40M70K40' => 37, 'C40Y70K40' => 38, 'C70M40K40' => 39, 'C100M100K60' => 40, 'M100Y100K60' => 41, 'C100Y100K60' => 42, 'C100M40' => 43, 'M100Y40' => 44, 'C40Y100' => 45, 'C10M40Y40' => 46, 'C20M70Y70' => 47, 'M70Y70K40' => 48, 'C70Y40K40' => 49, 'C100M100Y100' => 50, 'C80M70Y70K100' => 51, 'C100K60' => 52, 'M100K60 ' => 53 }
  
  def lab_to_rgb(l,a,b)
    # logger.error("************\nHERE\n#{self.id}\n************")
    if validate_lab?(l,a,b) then
      lab_file_content = "'Lab ' ; Data Format\nicEncodeValue ; Encoding\n"
      lab_file_content += "#{l} #{a} #{b}"

      # create random temp file name
      lab_file_path = "#{Rails.root}/tmp/#{(0...8).map{65.+(rand(25)).chr}.join}.txt"
      icc_profile_path = "#{Rails.root}/vendor/AdobeRgB1998.icc"
      lab_file = File.new(lab_file_path, 'w')
      lab_file.puts lab_file_content
      lab_file.close
      
      begin
      # trap for iccApplyNamedCmm not being installed
      raise "iccApplyNamedCmm not found in PAtH: #{`echo $PAtH`}" if "" == `which iccApplyNamedCmm`
        iccSystemCallValue = `iccApplyNamedCmm #{lab_file_path} 3 1 #{icc_profile_path} 1`.split(/;/)
        /(\d+)\.\d+\s+(\d+)\.\d+\s+(\d+)\.\d+/.match(iccSystemCallValue[-2])
        r, g, b = $1, $2, $3
      rescue RuntimeError => system_path_error
        r, g, b = 0, 0, 0
        logger.error("\n[ColorFormulas.lab_to_rgb::iccApplyNamedCmm] #{system_path_error}\n")
      ensure
        File.delete(lab_file_path)  
      end          
      
      # ensure ALL values are 0..255
      if validate_rgb?(r, g, b)
        return [r, g, b]
      else
        # unless all colors are valid return BLACK
        logger.error("\n[ColorFormulas.validate_rgb] ERROR with #{self.inspect}\n")
        return [0,0,0]
      end   
    else
      logger.error("\n[ColorFormulas.validate_lab] ERROR with #{self.inspect}")
      [0,0,0]
    end    
  end
  
  def to_hex(int)
    if int.to_s(16)
      # put 0 in front of the hex char to insure a two digit hex char
      /.*([A-z0-9]{2})$/.match("0#{int.to_s(16)}")
      return $1
    else
      logger.error("[ColorFormulas.to_hex] ERROR converting #{int.inspect} into a hex")
      "00"
    end    
  end

  def lab_dE2000(l1, a1, b1, l2, a2, b2)
    kl = 1
    kc = 1
    kh =1
    # FROM SetLabData -- NOt SURE IF NEEDED, but I think so
    c1 = Math::sqrt(a1 ** 2 + b1 ** 2)
    c2 = Math::sqrt(a2 ** 2 + b2 ** 2)
    h1 = Math::atan2(a1,b1) * (180 / Math::PI)
    if h1 < 0 
      h1 = h1 + 360
    end
    h2 = Math::atan2(a2,b2) * (180 / Math::PI)
    if h2 < 0 
      h2 = h2 + 360
    end

    # FROM dE2000
    lPrimeMean = (l1 + l2) / 2
    cMean = (c1 + c2) / 2
    g = (1 - Math::sqrt(cMean ** 7 / (cMean ** 7 + 25 ** 7))) / 2
    a1prime = a1 * (1 + g)
    a2prime = a2 * (1 + g)
    c1prime = Math::sqrt(a1prime ** 2 + b1 ** 2)
    c2prime = Math::sqrt(a2prime ** 2 + b2 ** 2)
    cPrimeMean = (c1prime + c2prime) / 2
    if Math::atan2(a1prime, b1) * (180 / Math::PI) >= 0 
      h1prime = Math::atan2(a1prime, b1) * (180 / Math::PI)
    else
      h1prime = Math::atan2(a1prime, b1) * (180 / Math::PI) + 360
    end

    if Math::atan2(a2prime, b2) * (180 / Math::PI) >= 0 
      h2prime = Math::atan2(a2prime, b2) * (180 / Math::PI)
    else
      h2prime = Math::atan2(a2prime, b2) * (180 / Math::PI) + 360
    end

    if (h1prime - h2prime).abs > 180 
      hPrimeMean = (h1prime + h2prime + 360) / 2
    else
      hPrimeMean = (h1prime + h2prime) / 2
    end

    t = 1 - 0.17 * Math::cos((hPrimeMean - 30) * (Math::PI / 180)) + 0.24 * Math::cos(2 * hPrimeMean * (Math::PI / 180)) + 0.32 * Math::cos((3 * hPrimeMean + 6) * (Math::PI / 180)) - 0.2 * Math::cos((4 * hPrimeMean - 63) * (Math::PI / 180))

    if (h2prime - h1prime).abs <= 180 
      dsHprime = h2prime - h1prime
    else
      if h2prime <= h1prime 
        dsHprime = h2prime - h1prime + 360
      else
        dsHprime = h2prime - h1prime - 360
      end
    end

    dLprime = l2 - l1
    dCprime = c2prime - c1prime
    dHprime2 = 2 * Math::sqrt(c1prime * c2prime) * Math::sin(dsHprime / 2 * (Math::PI / 180))
    sl = (0.015 * (lPrimeMean - 50) ** 2) / Math::sqrt(20 + (lPrimeMean - 50) ** 2) + 1
    sc = 1 + 0.045 * cPrimeMean
    sh = 1 + 0.015 * cPrimeMean * t
    dtheta = 30 * Math::exp(-1 * (((hPrimeMean - 275) / 25) ** 2))
    rc = Math::sqrt(cPrimeMean ** 7 / (cPrimeMean ** 7 + 25 ** 7))
    rt = -2 * rc * Math::sin(2 * dtheta * Math::PI / 180)
    deltaE2000 = Math::sqrt((dLprime / (kl * sl)) ** 2 + (dCprime / (kc * sc)) ** 2 + (dHprime2 / (kh * sh)) ** 2 + rt * (dCprime / (kc * sc)) * (dHprime2 / (kh * sh)))
    format("%.2f", deltaE2000).to_f
  end


private
  def validate_lab?(l,a,b)
    return false unless l && L_RANGE.include?(l.to_f)
    return false unless a && A_RANGE.include?(a.to_f)
    return false unless b && B_RANGE.include?(b.to_f)
    # if all these pass then it is ok
    true 
  end  
  
  def validate_rgb?(r, g, b)
    return false unless r.to_i && RGB_RANGE.include?(r.to_i)
    return false unless g.to_i && RGB_RANGE.include?(g.to_i)
    return false unless b.to_i && RGB_RANGE.include?(b.to_i)
    # if all these pass then it is ok
    true
  end
  
end
