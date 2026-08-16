result = {**({"value": value} if condition else {})}
other_result = {**({} if condition else {"value": value})}
