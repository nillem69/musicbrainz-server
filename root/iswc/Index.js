/*
 * @flow
 * Copyright (C) 2018 MetaBrainz Foundation
 *
 * This file is part of MusicBrainz, the open internet music database,
 * and is licensed under the GPL version 2, or (at your option) any
 * later version: http://www.gnu.org/licenses/gpl-2.0.txt
 */

import * as React from 'react';

import {withCatalystContext} from '../context';
import Layout from '../layout';
import CodeLink from '../static/scripts/common/components/CodeLink';
import WorkListEntry from '../static/scripts/common/components/WorkListEntry';
import {l, ln} from '../static/scripts/common/i18n';

type Props = {|
  +$c: CatalystContextT,
  +iswcs: $ReadOnlyArray<IswcT>,
  +works: $ReadOnlyArray<WorkT>,
|};

const Index = ({$c, iswcs, works}: Props) => {
  const userExists = $c.user_exists;
  const iswc = iswcs[0];
  return (
    <Layout fullWidth title={l('ISWC “{iswc}”', {iswc: iswc.iswc})}>
      <h1>
        {l('ISWC “{iswc}”',
          {iswc: <CodeLink code={iswc} key="iswc" />})}
      </h1>
      <h2>
        {ln(
          'Associated with {num} work',
          'Associated with {num} works',
          works.length,
          {num: works.length},
        )}
      </h2>
      <form action="/work/merge_queue" method="post">
        <table className="tbl">
          <thead>
            <tr>
              {userExists ? (
                <th style={{width: '1em'}}>
                  <input type="checkbox" />
                </th>
              ) : null}
              <th>{l('Title')}</th>
              <th>{l('Writers')}</th>
              <th>{l('Artists')}</th>
              <th>{l('Type')}</th>
              <th>{l('Language')}</th>
            </tr>
          </thead>
          <tbody>
            {works.map((work, index) => (
              <WorkListEntry
                hasISWCColumn={false}
                hasMergeColumn
                index={index}
                key={work.id}
                work={work}
              />
            ))}
          </tbody>
        </table>
        {userExists ? (
          <div className="row">
            <span className="buttons">
              <button type="submit">
                {l('Add selected works for merging')}
              </button>
            </span>
          </div>
        ) : null}
      </form>
    </Layout>
  );
};

export default withCatalystContext(Index);
