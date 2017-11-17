function varargout = subsref(obj,s)
   switch s(1).type
      case '.'
            varargout = {builtin('subsref',obj,s)};
      case '()'
         if length(s) == 1
             varargout = {obj.Get(s(1).subs{1})};
         else
            varargout = {builtin('subsref',obj.Get(s(1).subs{1}),s(2:end))};
         end
      case '{}'
            varargout = {builtin('subsref',obj,s)};
      otherwise
         error('Not a valid indexing expression')
   end
end
