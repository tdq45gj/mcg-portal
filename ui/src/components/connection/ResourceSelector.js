import React, {useState, useEffect} from 'react';
import FormControl from "@material-ui/core/FormControl";
import InputLabel from "@material-ui/core/InputLabel";
import Select from "@material-ui/core/Select";
import MenuItem from "@material-ui/core/MenuItem";
import Style from '../../lib/Style'

function ResourceSelector(props) {
    const validOptions = [
        'Panel Speaker',
        'Resume Review',
        'Mock Interview',
        'Job Shadow',
        'Career Advising',
        'Education Advising',
        'Job/Internship',
        'Temporary Housing',
        'Project Funding',
        'Project Partner',
    ];

    const selectItems = validOptions.map(opt => <MenuItem value={opt}>{opt}</MenuItem>);

    const [selection, setSelection] = useState(validOptions[0]);
    useEffect(() => {
        props.onChange(selection);
    }, [selection]);



    return (
        <FormControl variant="standard" style={{maxWidth: '100%'}}>
            <InputLabel id="resource-type-label" style={{fontFamily: Style.FontFamily}}>Resource Type</InputLabel>
            <Select
                labelId="resource-type-label"
                value={selection}
                onChange={e => setSelection(e.target.value)}
                label="Resource Name"
                style={{fontFamily: Style.FontFamily}}
            >
                {selectItems}
            </Select>
        </FormControl>
    )
}

export default ResourceSelector;