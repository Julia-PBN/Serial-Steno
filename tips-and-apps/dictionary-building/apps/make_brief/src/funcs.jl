# put your hand-maded functions there


I(brief, expand) = brief, expand  # don't remove that one! It's actually important for things to work correctly.
NULL(_, _) = "", ""  # don't remove that one! It's actually important for things to work corretly.



repeat_and(brief, expand) = brief, expand * " and " * expand  # random example, you can delete that

function clean_space(brief, expand)
    brief, replace(replace(expand, r" +" => " "), r"^ " => "", r" $" => "")
end