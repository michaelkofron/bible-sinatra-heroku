def bible_chapter(ref)
    array = ref.split(":")
    meat = array[0].split(" ")
    if meat[0] == "1"
        link = "https://www.kingjamesbibleonline.org/#{meat[0]}-#{meat[1]}-Chapter-#{meat[2]}"
    else
        link = "https://www.kingjamesbibleonline.org/#{meat[0]}-Chapter-#{meat[1]}"
    end
    link
end